import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';
import 'package:lumin_business/modules/suppliers/supply_order_model.dart';

List<SupplierModel> dummySupplierData = [
  SupplierModel(
      id: "1",
      name: "Tech Supplies Co.",
      contactNumber: "+1-555-1234",
      email: "support@techsupplies.com",
      orders: [
        SupplyOrder(
            orderId: "1",
            orderDate: DateTime.now(),
            orderedProducts: {
              "r": [100, 500.00],
              "s": [50, 3.99],
            },
            supplierId: '1',
            notes: "Some notes go here",
            status: OrderStatus.Pending),
        SupplyOrder(
            orderId: "2",
            orderDate: DateTime.now(),
            orderedProducts: {
              "r": [100, 500.00],
              "s": [50, 3.99],
            },
            supplierId: '1',
            notes: "Some notes go here",
            status: OrderStatus.Delivered),
      ],
      products: [],
      address: "123 Tech Avenue, Silicon Valley, CA"),
  SupplierModel(
      id: "2",
      name: "Office Essentials Ltd.",
      contactNumber: "+44-20-7890",
      email: "info@officeessentials.co.uk",
      orders: [],
      products: [],
      address: "456 Office Park, London, UK"),
  SupplierModel(
      id: "3",
      name: "Home Appliances Corp.",
      contactNumber: "+61-2-9876",
      email: "sales@homeappliances.com.au",
      orders: [],
      products: [],
      address: "789 Appliance St, Sydney, Australia"),
  SupplierModel(
      id: "4",
      name: "Global Footwear Inc.",
      contactNumber: "+91-22-123456",
      email: "contact@globalfootwear.in",
      orders: [],
      products: [],
      address: "101 Footwear Road, Mumbai, India"),
  SupplierModel(
      id: "5",
      name: "Furniture Masters",
      contactNumber: "+27-11-234567",
      email: "furniture@masters.co.za",
      orders: [],
      products: [],
      address: "303 Furniture Lane, Johannesburg, South Africa"),
  SupplierModel(
      id: "6",
      name: "Gadget Warehouse",
      contactNumber: "+1-555-5678",
      email: "orders@gadgetwarehouse.com",
      orders: [],
      products: [],
      address: "202 Gadget Blvd, New York, USA"),
  SupplierModel(
      id: "7",
      name: "Beverage Suppliers Ltd.",
      contactNumber: "+49-30-98765",
      email: "service@beveragesuppliers.de",
      orders: [],
      products: [],
      address: "67 Beverage Strasse, Berlin, Germany"),
  SupplierModel(
      id: "8",
      name: "Fashion Boutique Ltd.",
      contactNumber: "+33-1-234567",
      email: "sales@fashionboutique.fr",
      orders: [],
      products: [],
      address: "89 Rue de la Mode, Paris, France"),
  SupplierModel(
      id: "9",
      name: "Electronics Hub",
      contactNumber: "+81-3-567890",
      email: "support@electronicshub.jp",
      orders: [],
      products: [],
      address: "12 Tech Tower, Tokyo, Japan"),
  SupplierModel(
      id: "10",
      name: "Healthy Living Supplies",
      contactNumber: "+1-888-4321",
      email: "info@healthyliving.com",
      orders: [],
      products: [],
      address: "50 Wellness Way, Vancouver, Canada"),
];

class SupplierProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SupplierModel> allSuppliers = [];//dummySupplierData;
  bool isSuppliersFetched = false;
  List<String> supplierHeaders = [
    "ID",
    "Name",
    "Contact Number",
    "Email",
    "Address"
  ];

  void clearData() {
    isSuppliersFetched = false;
    allSuppliers = [];
    notifyListeners();
  }

  void uploadSuppliersFromCSV() async {
    try {
      List<SupplierModel> suppliers =
          await CSVModule.uploadFromCSV<SupplierModel>(
        supplierHeaders,
        (rowMap) => SupplierModel.fromMap(rowMap),
      );
      print("Suppliers uploaded: ${suppliers.length}");
    } catch (e) {
      print("Error uploading suppliers: $e");
    }
  }

  Future<void> updateSupplier(
      SupplierModel updatedSupplier, String businessID) async {
    try {
      await _firestore
          .collection('businesses')
          .doc(businessID)
          .collection("products")
          .doc(updatedSupplier.id)
          .set(updatedSupplier.toMap());

      for (SupplierModel s in allSuppliers) {
        if (s.id == updatedSupplier.id) {
          int index = allSuppliers.indexOf(s);
          allSuppliers[index] = updatedSupplier;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void downloadSuppliersToCSV() {
    CSVModule.downloadToCSV<SupplierModel>(
        allSuppliers,
        ["ID", "Name", "Contact Number", "Email", "Address"],
        (supplier) => [
              supplier.id,
              supplier.name,
              supplier.contactNumber,
              supplier.email,
              supplier.address
            ],
        "Suppliers");
  }

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
