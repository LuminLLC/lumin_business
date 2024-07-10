import 'package:flutter/material.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';

List<CustomerModel> dummyProductData = [
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
  List allCustomers = dummyProductData; //[];
  bool isCustomersFetched = true;
}
