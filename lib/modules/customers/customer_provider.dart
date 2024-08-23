import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';

List<CustomerModel> dummyCustomerData = [
  CustomerModel(
      id: "id",
      name: "Stan Smith",
      address: "123 Apple Street, Any Town",
      email: "stan@luminllc.com",
      phoneNumber: "phoneNumber",
      orders: []),
  CustomerModel(
      id: "id",
      name: "Abigail Smith",
      address: "123 Apple Street, Any Town",
      email: "stan@luminllc.com",
      phoneNumber: "phoneNumber",
      orders: []),
];

class CustomerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CustomerModel> allCustomers = [];
  bool isCustomersFetched = false;

  Future<void> addCustomer(CustomerModel c, String businessID) async {
    try {
      await _firestore
          .collection("businesses")
          .doc(businessID)
          .collection("customers")
          .doc(c.id)
          .set(c.toMap());
      allCustomers.add(c);
      // allCustomers.sort((a, b) => a.date.compareTo(b.date));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchCustomers(String businessID) async {
    if (!isCustomersFetched) {
      try {
        QuerySnapshot<Map<String, dynamic>> rawDocs = await _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("customers")
            .get();
        for (var v in rawDocs.docs) {
          allCustomers.add(CustomerModel.fromMap(v.data()));
        }
        // allCustomers.sort((a, b) => a.date.compareTo(b.date));
        isCustomersFetched = true;

        notifyListeners();
      } catch (e) {
        print("error fetching customers");
      }
    }
  }
}
