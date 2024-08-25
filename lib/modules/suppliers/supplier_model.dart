import 'package:lumin_business/modules/inventory/product_model.dart';

import 'supply_order_model.dart';

 

class SupplierModel {
  String id;
  String name;
  String contactNumber;
  String email;
  String address;
  List<ProductModel> products = [];
  List<SupplyOrder> orders = [];

  // Constructor
  SupplierModel(
      {required this.id,
      required this.name,
      required this.contactNumber,
      required this.email,
      required this.address,
      required this.products,
      required this.orders});

  // Method to convert SupplierModel object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
      'products': products,
      'orders': orders
    };
  }

  // Static method to create a SupplierModel object from a map
  static SupplierModel fromMap(Map<String, dynamic> map) {
    return SupplierModel(
        id: map['id'],
        name: map['name'],
        contactNumber: map['contactNumber'],
        email: map['email'],
        address: map['address'],
        orders: map['orders'] ?? [],
        products: map['products']??[]);
  }
}
