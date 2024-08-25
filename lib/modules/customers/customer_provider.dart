import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';

List<CustomerModel> dummyCustomerData = [
  CustomerModel(
      id: "1",
      name: "Jane Doe",
      address: "456 Maple Avenue, Springfield",
      email: "jane.doe@example.com",
      phoneNumber: "+1-555-9876",
      orders: []),
  CustomerModel(
      id: "2",
      name: "John Adams",
      address: "789 Oak Road, Capital City",
      email: "john.adams@example.com",
      phoneNumber: "+1-555-5432",
      orders: []),
  CustomerModel(
      id: "3",
      name: "Emily Turner",
      address: "101 Pine Street, Oceanview",
      email: "emily.turner@example.com",
      phoneNumber: "+44-20-1234",
      orders: []),
  CustomerModel(
      id: "4",
      name: "Michael Jordan",
      address: "202 Cedar Lane, River Town",
      email: "mjordan@hoopmail.com",
      phoneNumber: "+1-555-9870",
      orders: []),
  CustomerModel(
      id: "5",
      name: "Sophia Martinez",
      address: "303 Birch Boulevard, Greenfield",
      email: "sophia.martinez@example.com",
      phoneNumber: "+34-91-567890",
      orders: []),
  CustomerModel(
      id: "6",
      name: "Carlos Gomez",
      address: "404 Elm Drive, Palm Beach",
      email: "carlos.gomez@example.com",
      phoneNumber: "+52-55-789012",
      orders: []),
  CustomerModel(
      id: "7",
      name: "Olivia Brown",
      address: "505 Willow Way, Meadowland",
      email: "olivia.brown@example.com",
      phoneNumber: "+1-555-3456",
      orders: []),
  CustomerModel(
      id: "8",
      name: "Liam Wong",
      address: "606 Redwood Court, Hilltop",
      email: "liam.wong@example.com",
      phoneNumber: "+61-3-456789",
      orders: []),
  CustomerModel(
      id: "9",
      name: "Alice Johnson",
      address: "707 Palm Circle, Seaside",
      email: "alice.johnson@example.com",
      phoneNumber: "+49-30-123456",
      orders: []),
  CustomerModel(
      id: "10",
      name: "David Lee",
      address: "808 Cypress Place, Mountainview",
      email: "david.lee@example.com",
      phoneNumber: "+82-2-987654",
      orders: []),
];

class CustomerProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<CustomerModel> allCustomers = []; //dummyCustomerData;
  bool isCustomersFetched = false;
  List<String> customerHeaders = [
    "id",
    "name",
    "email",
    "phoneNumber",
    "address"
  ];

  void uploadCustomersFromCSV() async {
    try {
      List<CustomerModel> customers =
          await CSVModule.uploadFromCSV<CustomerModel>(
        customerHeaders,
        (rowMap) => CustomerModel.fromMap(rowMap),
      );
      print("Customers uploaded: ${customers.length}");
    } catch (e) {
      print("Error uploading customers: $e");
    }
  }

  Future<void> updateCustomer(
      CustomerModel updatedCustomer, String businessID) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("customers")
          .doc(updatedCustomer.id)
          .set(updatedCustomer.toMap());

      for (CustomerModel c in allCustomers) {
        if (c.id == updatedCustomer.id) {
          int index = allCustomers.indexOf(c);
          allCustomers[index] = updatedCustomer;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void downloadCustomersToCSV() {
    CSVModule.downloadToCSV<CustomerModel>(
        allCustomers,
        ["ID", "Name", "Email", "Phone Number", "Address"],
        (customer) => [
              customer.id,
              customer.name,
              customer.email,
              customer.phoneNumber,
              customer.address
            ],
        "Customers");
  }

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
