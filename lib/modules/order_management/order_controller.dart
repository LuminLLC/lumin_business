import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  Map<ProductModel, int> openOrder = {};
  String? quantityError;

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

  Future<void> completeOrder(String businessID, BuildContext context) async {
    notifyListeners();
    for (ProductModel p in openOrder.keys) {
      await Provider.of<InventoryProvider>(context, listen: false)
          .decreaseProductQuantity(p, openOrder[p]!, businessID);
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
}
