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
  List allSuppliers = dummySupplierData; //[];
  bool isSuppliersFetched = true;
}
