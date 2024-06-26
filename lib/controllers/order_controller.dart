import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/models/lumin_order.dart';
import 'package:intl/intl.dart';

class OrderController with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
}
