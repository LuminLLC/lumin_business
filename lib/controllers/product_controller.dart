import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumin_business/models/category.dart'; 
import 'package:lumin_business/models/product.dart';

class ProductController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<Product, int> openOrder = {};
  String? quantityError;
  bool isProductFetched = false;

  List<Product> allProdcuts = [];
  List<ProductCategory> categories = [];
  Map<String, List<Product>> productMap = {};
  List<Product> searchResults = [];
  List<ProductCategory> productCategories = [];

  searchProduct(String query) {
    searchResults = allProdcuts
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> addProduct(Product p, String businessID) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("inventory")
          .doc("all_products")
          .update({
        p.category: FieldValue.arrayUnion([
          {
            p.name: {"id": p.id, "qty": p.quantity, "unit_price": p.unitPrice}
          }
        ])
      });
      allProdcuts.add(p);
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

//orders
  Future<void> completeOrder(String businessID) async {
    notifyListeners();
    for (Product p in openOrder.keys) {
      await decreaseProductQuantity(p, openOrder[p]!, businessID);
    }
    await addOrderToHistory(businessID, "fulfilled");
    openOrder.clear();
    notifyListeners();
  }

  Map<Product, int> fetchOpenOrder() {
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
      for (Product p in openOrder.keys) {
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
      for (Product p in openOrder.keys) {
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

  addToOrder(Product p, int quantity) {
    if (openOrder.containsKey(p)) {
      openOrder[p] = openOrder[p]! + quantity;
    } else {
      openOrder[p] = quantity;
    }
    notifyListeners();
  }

  bool verifyQuantity(Product p, int quantity) {
    if (p.quantity >= quantity) {
      return true;
    }
    return false;
  }

  int calculateOutofStock() {
    int outOfStock = 0;
    for (Product product in allProdcuts) {
      if (product.quantity == 0) {
        outOfStock++;
      }
    }
    return outOfStock;
  }

  int calculateCriticalLevel() {
    int criticalLevel = 0;
    for (Product product in allProdcuts) {
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

  createNewCategory(ProductCategory c, String businessID) async {
    _firestore
        .collection('businesses')
        .doc(businessID)
        .collection("product_categories")
        .doc(c.name)
        .set({"code": generateCategoryCode(c.name, _getCategoryCount())});
  }

  String getCategoryCode(Product p) {
    for (ProductCategory c in categories) {
      if (p.category == c.name) {
        return c.code;
      }
    }
    return "";
  }

//Products
  String generateProductCode(String categoryCode, Product p) {
    int position = allProdcuts.indexOf(p);

    return categoryCode + "P" + position.toString();
  }

  Future<void> fetchProducts(String businessID) async {
    QuerySnapshot<Map<String, dynamic>> tempList = await _firestore
        .collection('businesses')
        .doc(businessID)
        .collection("products")
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> element in tempList.docs) {
      allProdcuts.add(Product(
          id: element.id,
          name: element.data()["name"],
          quantity: element.data()["quantity"],
          category: element.data()["category"],
          unitPrice: element.data()["unitPrice"]));
    }
    isProductFetched = true;
    notifyListeners();
    await getCategories(businessID);
  }

  Future<void> decreaseProductQuantity(
      Product p, int orderQuantity, String businessID) async {
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

  Future<void> deleteProduct(Product p, String businessID) async {
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
