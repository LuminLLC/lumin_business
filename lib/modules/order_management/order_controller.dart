import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/order_management/lumin_order.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

List<LuminOrder> dummyOrders = [
  LuminOrder(
      orderId: "1234",
      orderItems: [
        OrderItem(productID: "AO6P142", quantity: 2, price: 100.0),
        OrderItem(productID: "BC23P45", quantity: 1, price: 50.0),
      ],
      pos: "Store",
      status: "fulfilled"),
  LuminOrder(
      orderId: "1235",
      orderItems: [
        OrderItem(productID: "AO6P142", quantity: 2, price: 100.0),
        OrderItem(productID: "BC23P45", quantity: 1, price: 50.0),
      ],
      customer: "Saint Janney",
      pos: "Store",
      status: "fulfilled"),
];

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  List<LuminOrder>? todayOrders;

  var uuid = Uuid();
  LuminOrder? openOrder;
  String? quantityError;

  ProductModel productLookup(String id, BuildContext context) {
    return Provider.of<InventoryProvider>(context, listen: false)
        .getProductWithID(id);
  }

  Future<Map<String, List<LuminOrder>>> fetchAllOrders(
      String businessID) async {
    Map<String, List<LuminOrder>> allOrders = {};
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection('orders')
          .get();

      if (snapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> element
            in snapshot.docs) {
          allOrders[element.id] = [];
          for (var order in element.data().values) {
            allOrders[element.id]!.add(LuminOrder.fromMap(order));
          }
        }
      }

      return allOrders;
    } on Exception {
      return allOrders;
    }
  }

  Future<void> fetchTodaysOrders(String businessID) async {
    if (todayOrders == null) {
      todayOrders = [];
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      try {
        final DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection('businesses')
            .doc(businessID)
            .collection('orders')
            .doc(today)
            .get();

        if (snapshot.exists) {
          print(snapshot.data());
          for (Map<String, dynamic> element
              in snapshot.data()!.values.toList()) {
            todayOrders!.add(LuminOrder.fromMap(element));
          }
        }
      } on Exception catch (e) {
        print("here");
        print(e);
      }
      notifyListeners();
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

  void setOrderPos(String pos) {
    openOrder!.pos = pos;
    notifyListeners();
  }

  Widget getOrderStatus(List<dynamic> items) {
    String status = items.first['status'];
    return Text(
      status,
      style: TextStyle(color: status == "canceled" ? Colors.red : Colors.green),
    );
  }

  Future<void> completeOrder(String businessID, BuildContext context) async {
    for (OrderItem item in openOrder!.orderItems) {
      ProductModel p = productLookup(item.productID, context);
      if (!verifyQuantity(p, item.quantity)) {
        setQuantityError("Quantity not available for ${p.name}");
        return;
      } else {
        await Provider.of<InventoryProvider>(context, listen: false)
            .decreaseProductQuantity(p, item.quantity, businessID);
      }
    }
    openOrder!.setOrderStatus("fulfilled");
    await addOrderToHistory(businessID);
    await addOrdertoAccounts(businessID, context);
    openOrder = null;
    notifyListeners();
  }

  LuminOrder? fetchOpenOrder() {
    return openOrder;
  }

  Future<void> addOrdertoAccounts(
      String businessID, BuildContext context) async {
    await Provider.of<AccountingProvider>(context, listen: false)
        .addTransaction(
            AccountingModel(
                id: uuid.v1(),
                saleID: openOrder!.orderId,
                description: "Sale Order ID: ${openOrder!.orderId}",
                amount: openOrder!.orderTotal,
                date: LuminUtll.formatDate(DateTime.now()),
                type: TransactionType.income),
            businessID);
  }

  Future<void> addOrderToHistory(String businessID) async {
    String todayDateString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore
              .collection("businesses")
              .doc(businessID)
              .collection("orders")
              .doc(todayDateString)
              .get();

      if (documentSnapshot.exists) {
        _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("orders")
            .doc(todayDateString)
            .update({
          DateTime.now().microsecondsSinceEpoch.toString(): openOrder!.toMap()
        });
      } else {
        _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("orders")
            .doc(todayDateString)
            .set({
          DateTime.now().microsecondsSinceEpoch.toString(): openOrder!.toMap()
        });
      }
    } catch (e) {
      print(e);
    }
    print(openOrder!.toMap());
    todayOrders!.add(openOrder!);
    notifyListeners();
  }

  Future<void> clearOpenOrder(String businessID) async {
    openOrder!.setOrderStatus("canceled");
    await addOrderToHistory(businessID);
    openOrder = null;
    notifyListeners();
  }

  setQuantityError(String? error) {
    quantityError = error;
    notifyListeners();
  }

  addToOrder(ProductModel p, int quantity) {
    if (openOrder == null) {
      openOrder = LuminOrder(orderId: uuid.v1(), orderItems: [
        OrderItem(productID: p.id!, quantity: quantity, price: p.unitPrice)
      ]);
    } else if (openOrder!.productIDs.contains(p.id)) {
      openOrder!.orderItems.forEach((element) {
        if (element.productID == p.id) {
          element.quantity += quantity;
        }
      });
    } else {
      openOrder!.orderItems.add(
          OrderItem(productID: p.id!, quantity: quantity, price: p.unitPrice));
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
