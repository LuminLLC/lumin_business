import 'package:lumin_business/modules/inventory/lumin_order.dart';

class CustomerModel {
  // Properties
  String id;
  String name;
  String email;
  String phoneNumber;
  String address;
  List<LuminOrder> orders;

  // Constructor
  CustomerModel(
      {required this.id,
      required this.name,
      required this.address,
      required this.email,
      required this.phoneNumber,
      required this.orders});

  // Method to convert a Customer object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address
      // Assuming 'orders' is a List<Order> and Order has a toMap method
      // 'orders': orders.map((order) => order.toMap()).toList(),
    };
  }

  // Static method to create a Customer object from a map
  static CustomerModel fromMap(Map<String, dynamic> map) {
    return CustomerModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        phoneNumber: map['phoneNumber'],
        address: map["address"],
        orders: []
        // Assuming you have a corresponding fromMap method for Order
        // orders: List<Order>.from(map['orders']?.map((orderMap) => Order.fromMap(orderMap))),
        );
  }

  // // Method to update customer information
  // void updateInfo({String? name, String? email, String? phoneNumber}) {
  //   if (name != null) this.name = name;
  //   if (email != null) this.email = email;
  //   if (phoneNumber != null) this.phoneNumber = phoneNumber;
  // }

  @override
  String toString() {
    return 'Customer ID: $id\nName: $name\nEmail: $email\nPhone Number: $phoneNumber';
  }
}
