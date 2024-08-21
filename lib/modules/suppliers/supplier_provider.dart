import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';

List<SupplierModel> dummySupplierData = [
  SupplierModel(
      id: "id",
      name: "name",
      contactNumber: "contactNumber",
      email: "email",
      address: "address"),
  SupplierModel(
      id: "id",
      name: "name",
      contactNumber: "contactNumber",
      email: "email",
      address: "address"),
  SupplierModel(
      id: "id",
      name: "name",
      contactNumber: "contactNumber",
      email: "email",
      address: "address"),
  SupplierModel(
      id: "id",
      name: "name",
      contactNumber: "contactNumber",
      email: "email",
      address: "address"),
  SupplierModel(
      id: "id",
      name: "name",
      contactNumber: "contactNumber",
      email: "email",
      address: "address"),
];

class SupplierProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SupplierModel> allSuppliers = [];
  bool isSuppliersFetched = false;

  Future<void> addSupplier(SupplierModel s, String businessID) async {
    try {
      await _firestore
          .collection("businesses")
          .doc(businessID)
          .collection("suppliers")
          .doc(s.id)
          .set(s.toMap());
      allSuppliers.add(s);
      // allCustomers.sort((a, b) => a.date.compareTo(b.date));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchSuppliers(String businessID) async {
    if (!isSuppliersFetched) {
      try {
        QuerySnapshot<Map<String, dynamic>> rawDocs = await _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("suppliers")
            .get();
        for (var v in rawDocs.docs) {
          allSuppliers.add(SupplierModel.fromMap(v.data()));
        }
        // allCustomers.sort((a, b) => a.date.compareTo(b.date));
        isSuppliersFetched = true;

        notifyListeners();
      } catch (e) {
        print("error fetching customers");
      }
    }
  }
}
