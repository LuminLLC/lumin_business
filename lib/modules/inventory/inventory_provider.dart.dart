import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/inventory/category.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:universal_html/html.dart' as html;

List<ProductModel> dummyProductData = [
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
  ProductModel(
      id: "id",
      name: "name",
      quantity: 20,
      category: "category",
      unitPrice: 1.2),
];

class InventoryProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  String? selectedCategory;
  File? photo;
  Map<ProductModel, int> openOrder = {};
  String? quantityError;
  bool isProductFetched = true;
  List<ProductModel> allProdcuts = dummyProductData;//[];
  List<ProductCategory> categories = [];
  Map<String, List<ProductModel>> productMap = {};

  void clearSelectedCategory() {
    selectedCategory = null;
    notifyListeners();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getTodaysOrders(
      String businessID) {
    String todayDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      return _firestore
          .collection('businesses')
          .doc(businessID)
          .collection('orders')
          .doc(todayDateString)
          .snapshots();
    } catch (e) {
      return Stream.empty();
    }
  }

  double getOrderTotal(List<dynamic> items) {
    print(items);
    double total = 0;
    for (Map<String, dynamic> item in items) {
      if (item['status'] != 'canceled') {
        total += item['unitPrice'] * item['quantity'];
      }
    }
    return total;
  }

  Widget getOrderStatus(List<dynamic> items) {
    String status = items.first['status'];
    return Text(
      status,
      style: TextStyle(color: status == "canceled" ? Colors.red : Colors.green),
    );
  }

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void clearNewProduct() {
    photo = null;
    notifyListeners();
  }

  void uploadImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement()
      ..accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoad.listen((event) {
        print("done");
      });
    });
  }

  Future getImage() async {
    var maxFileSizeInBytes = 2 * 1048576;
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    var imagePath = await pickedFile!.readAsBytes();
    var fileSize = imagePath.length; // Get the file size in bytes
    if (fileSize <= maxFileSizeInBytes) {
      photo = File(pickedFile.path);
    } else {
      // File is too large, ask user to upload a smaller file, or compress the file/image
    }

    notifyListeners();
  }

  Future<String> uploadImageToFirebase(String fileName) async {
    if (photo == null) return "";
    Uint8List imageData = await XFile(photo!.path).readAsBytes();
    try {
      final ref =
          FirebaseStorage.instance.ref().child('product_images/$fileName');
      final uploadTask = ref.putData(imageData);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print("success");
      return downloadUrl;
    } catch (e) {
      print('error occured: $e');
      return "";
    }
  }

  int inventoryCount() {
    int sum = 0;
    for (ProductModel p in allProdcuts) {
      sum += p.quantity;
    }
    return sum;
  }

  Future<void> addProduct(
      ProductModel p, String businessID, String categoryCode) async {
    // String categoryCode = generateCategoryCode(input, number);
    String productCode = generateProductCode(categoryCode, p);
    Uint8List? imageData;
    if (photo != null) {
      print("not null");
      imageData = await XFile(photo!.path).readAsBytes();
    }

    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .doc(productCode)
          .set({
        "name": p.name,
        "image": imageData ?? "",
        "quantity": p.quantity,
        "category": p.category,
        "unitPrice": p.unitPrice
      });
      p.image = imageData != null ? imageData : null;
      allProdcuts.add(p);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

//orders
  Future<void> completeOrder(String businessID) async {
    notifyListeners();
    for (ProductModel p in openOrder.keys) {
      await decreaseProductQuantity(p, openOrder[p]!, businessID);
    }
    await addOrderToHistory(businessID, "fulfilled");
    openOrder.clear();
    notifyListeners();
  }

  Map<ProductModel, int> fetchOpenOrder() {
    return openOrder;
  }

  Future<void> addOrderToHistory(String businessID, String status) async {
    String todayDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String position = "1";
    Map<String, List<Map<String, dynamic>>> order = {};
    final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("orders")
            .doc(todayDateString)
            .get();

    if (documentSnapshot.exists) {
      position = (documentSnapshot.data()!.length + 1).toString();
      for (ProductModel p in openOrder.keys) {
        if (!order.containsKey(position)) {
          order[position] = [];
        }
        order[position]!.add({
          "product": p.name,
          "quantity": openOrder[p],
          "unitPrice": p.unitPrice,
          "totalPrice": p.unitPrice * openOrder[p]!,
          "status": status
        });
        // position = (int.parse(position) + 1).toString();
      }
      print(order);
      _firestore
          .collection("businesses")
          .doc(businessID)
          .collection("orders")
          .doc(todayDateString)
          .update(order);
    } else {
      for (ProductModel p in openOrder.keys) {
        if (!order.containsKey(position)) {
          order[position] = [];
        }
        order[position]!.add({
          "product": p.name,
          "quantity": openOrder[p],
          "unitPrice": p.unitPrice,
          "totalPrice": p.unitPrice * openOrder[p]!,
          "status": status
        });
        // position = (int.parse(position) + 1).toString();
      }
      _firestore
          .collection("businesses")
          .doc(businessID)
          .collection("orders")
          .doc(todayDateString)
          .set(order);
    }
  }

  Future<void> clearOpenOrder(String businessID) async {
    await addOrderToHistory(businessID, "canceled");
    openOrder.clear();
    notifyListeners();
  }

  setQuantityError(String? error) {
    quantityError = error;
    notifyListeners();
  }

  addToOrder(ProductModel p, int quantity) {
    if (openOrder.containsKey(p)) {
      openOrder[p] = openOrder[p]! + quantity;
    } else {
      openOrder[p] = quantity;
    }
    notifyListeners();
  }

  bool verifyQuantity(ProductModel p, int quantity) {
    if (p.quantity >= quantity) {
      return true;
    }
    return false;
  }

  int calculateAboveCriticalLevel() {
    int aboveCriticalLevel = 0;
    for (ProductModel product in allProdcuts) {
      if (product.quantity >= 10) {
        aboveCriticalLevel++;
      }
    }
    return aboveCriticalLevel;
  }

  int calculateOutofStock() {
    int outOfStock = 0;
    for (ProductModel product in allProdcuts) {
      if (product.quantity == 0) {
        outOfStock++;
      }
    }
    return outOfStock;
  }

  int calculateCriticalLevel() {
    int criticalLevel = 0;
    for (ProductModel product in allProdcuts) {
      if (product.quantity < 10) {
        criticalLevel++;
      }
    }
    return criticalLevel;
  }

  String generateCategoryCode(String input, int number) {
    List<String> words = input.trim().split(' ');
    String initials;

    if (words.length >= 2) {
      initials = words[0][0].toUpperCase() +
          words[1][0].toUpperCase() +
          number.toString();
    } else if (words.length == 1) {
      initials = words[0].substring(0, 2).toUpperCase() + number.toString();
    } else {
      // Handle empty or invalid input
      initials = "";
    }

    return initials;
  }

//Categories
  Future<void> getCategories(String businessID) async {
    try {
      QuerySnapshot<Map<String, dynamic>> temp = await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("product_categories")
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> element in temp.docs) {
        categories.add(
            ProductCategory(name: element.id, code: element.data()["code"]));
      }
      notifyListeners();
    } on Exception {
      throw Exception();
    }
  }

  int _getCategoryCount() {
    return categories.length;
  }

  Future<String> createNewCategory(String c, String businessID) async {
    String newCategory = generateCategoryCode(c, _getCategoryCount());
    await _firestore
        .collection('businesses')
        .doc(businessID)
        .collection("product_categories")
        .doc(c)
        .set({"code": newCategory});
    return newCategory;
  }

  String getCategoryCode(ProductModel p) {
    for (ProductCategory c in categories) {
      if (p.category == c.name) {
        return c.code;
      }
    }
    return "";
  }

//Products
  String generateProductCode(String categoryCode, ProductModel p) {
    int position = allProdcuts.indexOf(p);

    return categoryCode + "P" + position.toString();
  }

  Future<Uint8List> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      print(response.body);
      return Uint8List(0);
    }
  }

// Future<Uint8List?> downloadImage(String imagePath) async {
//   try {
//     final storageRef = FirebaseStorage.instance.ref().child(imagePath);
//     final Uint8List? imageData = await storageRef.getData();
//     return imageData;
//   } catch (e) {
//     print('Error downloading image: $e');
//     return null;
//   }
// }

  Future<void> fetchProducts(String businessID) async {
    if (!isProductFetched) {
      allProdcuts = [];
      QuerySnapshot<Map<String, dynamic>> tempList = await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> element
          in tempList.docs) {
        allProdcuts.add(ProductModel(
            id: element.id,
            image: element.data()["image"],
            name: element.data()["name"],
            quantity: element.data()["quantity"],
            category: element.data()["category"],
            unitPrice: element.data()["unitPrice"]));
      }
      isProductFetched = true;
      notifyListeners();
      await getCategories(businessID);
    }
  }

  Future<void> updateProduct(
      ProductModel updatedProduct, String businessID) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .doc(updatedProduct.id)
          .set(updatedProduct.toMap());

      for (ProductModel p in allProdcuts) {
        if (p.id == updatedProduct.id) {
          int index = allProdcuts.indexOf(p);
          allProdcuts[index] = updatedProduct;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> decreaseProductQuantity(
      ProductModel p, int orderQuantity, String businessID) async {
    bool sentinel = true;
    int index = 0;
    int upatedQuantity = 0;

    while (sentinel && index < allProdcuts.length) {
      if (allProdcuts.elementAt(index) == p) {
        allProdcuts.elementAt(index).quantity -= orderQuantity;
        upatedQuantity = allProdcuts.elementAt(index).quantity;
        sentinel == false;
      }
      index++;
    }

    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .doc(p.id)
          .update({"quantity": upatedQuantity});
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> deleteProduct(ProductModel p, String businessID) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .doc(p.id)
          .delete();

      allProdcuts.remove(p);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
