import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/inventory/category.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:universal_html/html.dart' as html;

List<ProductCategory> dummyCategories = [
  ProductCategory(name: "Electrocics", code: "code"),
  ProductCategory(name: "Furniture", code: "code"),
  ProductCategory(name: "Appliances", code: "code"),
  ProductCategory(name: "Footwear", code: "code"),
  ProductCategory(name: "Accessories", code: "code"),
  ProductCategory(name: "Entertainment", code: "code"),
];

List<ProductModel> dummyProductData = [
  ProductModel(
      id: "1",
      name: "Laptop",
      quantity: 15,
      category: "Electronics",
      unitPrice: 1200.0,
      unitCost: 10),
  ProductModel(
      id: "2",
      name: "Smartphone",
      quantity: 30,
      category: "Electronics",
      unitCost: 10,
      unitPrice: 800.0),
  ProductModel(
      id: "3",
      name: "Office Chair",
      quantity: 25,
      category: "Furniture",
      unitCost: 10,
      unitPrice: 150.0),
  ProductModel(
      id: "4",
      name: "Coffee Maker",
      quantity: 40,
      category: "Appliances",
      unitCost: 10,
      unitPrice: 60.0),
  ProductModel(
      id: "5",
      name: "Running Shoes",
      quantity: 50,
      category: "Footwear",
      unitCost: 10,
      unitPrice: 85.0),
  ProductModel(
      id: "6",
      name: "Blender",
      quantity: 20,
      category: "Appliances",
      unitCost: 10,
      unitPrice: 45.0),
  ProductModel(
      id: "7",
      name: "Wireless Mouse",
      quantity: 100,
      category: "Accessories",
      unitCost: 10,
      unitPrice: 25.0),
  ProductModel(
      id: "8",
      name: "Desk Lamp",
      quantity: 70,
      category: "Furniture",
      unitCost: 10,
      unitPrice: 35.0),
  ProductModel(
      id: "9",
      name: "Gaming Console",
      quantity: 10,
      category: "Entertainment",
      unitCost: 10,
      unitPrice: 500.0),
  ProductModel(
      id: "10",
      name: "Water Bottle",
      quantity: 200,
      category: "Accessories",
      unitCost: 10,
      unitPrice: 12.0),
];

class InventoryProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  String? selectedCategory;
  File? photo;
  Map<ProductModel, int> openOrder = {};
  String? quantityError;
  bool isProductFetched = true;
  List<ProductModel> allProdcuts = dummyProductData;
  List<ProductCategory> categories = dummyCategories;
  Map<String, List<ProductModel>> productMap = {};
  List<String> productHeaders = [
    "ID",
    "Name",
    "Category",
    "Quantity",
    "Unit Price",
  ];

  void clearData() {
    isProductFetched = false;
    openOrder.clear();
    allProdcuts.clear();
    categories.clear();
    notifyListeners();
  }

  void uploadProductsFromCSV() async {
    try {
      List<ProductModel> products = await CSVModule.uploadFromCSV<ProductModel>(
        productHeaders,
        (rowMap) => ProductModel.fromMap(rowMap),
      );
      print("Products uploaded: ${products.length}");
    } catch (e) {
      print("Error uploading products: $e");
    }
  }

  double get totalProuctCost {
    double total = 0;
    if (allProdcuts.isEmpty) {
      return total;
    } else {
      for (ProductModel p in allProdcuts) {
        total += p.unitCost;
      }
      return total;
    }
  }

  void downloadProductsToCSV() {
    CSVModule.downloadToCSV<ProductModel>(
        allProdcuts,
        ["ID", "Name", "Quantity", "Category", "Unit Cost", "Unit Price"],
        (product) => [
              product.id,
              product.name,
              product.quantity,
              product.category,
              product.unitCost,
              product.unitPrice
            ],
        "Products");
  }

  void clearSelectedCategory() {
    selectedCategory = null;
    notifyListeners();
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

  void cleanDB(String businessID) async {
    QuerySnapshot<Map<String, dynamic>> tempList = await _firestore
        .collection("businesses")
        .doc(businessID)
        .collection("products")
        .get();
    int count = 0;
    for (QueryDocumentSnapshot<Map<String, dynamic>> element in tempList.docs) {
      if (element.data()["name"] == null ||
          element.data()["quantity"] == null ||
          element.data()["category"] == null ||
          element.data()["unitPrice"] == null) {
        count++;
        await _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("products")
            .doc(element.id)
            .delete();
      }
    }
    print("${count} items deleted");
  }

  Future<void> fetchProducts(String businessID) async {
    print(isProductFetched);
    if (!isProductFetched) {
      allProdcuts = [];
      try {
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
              unitCost: element.data()["unitCost"] ?? 0,
              category: element.data()["category"],
              unitPrice: element.data()["unitPrice"]));
        }
      } catch (e) {
        print(e);
      }

      isProductFetched = true;
      notifyListeners();
      await getCategories(businessID);
    }
  }

  Future<void> updateProduct(
      ProductModel updatedProduct, String businessID) async {
    print(updatedProduct);
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
