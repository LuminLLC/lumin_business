import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:lumin_business/modules/user_and_busness/business_model.dart';
import 'package:lumin_business/modules/user_and_busness/lumin_user.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  String searchText = "";
  BusinessModel? businessInfo;
  LuminUser? user;
  int? index = null;

  void masterClearData(BuildContext context) {
    searchText = "";
    businessInfo = null;
    user = null;
    index = 0;
    Provider.of<AccountingProvider>(context, listen: false).clearData();
    Provider.of<InventoryProvider>(context, listen: false).clearData();
    Provider.of<CustomerProvider>(context, listen: false).clearData();
    Provider.of<SupplierProvider>(context, listen: false).clearData();
    notifyListeners();
  }

  Future<String> _fetchBusinessID(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> rawUser =
        await _firestore.collection("users").doc(userID).get();
    String businessID = rawUser.data()!["business_id"];
    return businessID;
  }

  Future<dynamic> setBusiness(
      {required String user,
      required String businessName,
      required String businessType,
      required String address,
      required String contact,
      required String ref}) async {
    try {
      String businessID = await _fetchBusinessID(user);
      await _firestore.collection("businesses").doc(businessID).update({
        "business_name": businessName,
        "business_type": businessType,
        "contact_number": contact,
        "location": address,
        "ref": ref
      });
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  void setSearchText(newText) {
    searchText = newText;
    notifyListeners();
  }

  void setIndex(int i) {
    if (index != i) {
      setSearchText("");
      index = i;
      notifyListeners();
    }
  }

  Future<void> fetchBusiness(String businessID) async {
    if (businessInfo == null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> temp =
            await _firestore.collection('businesses').doc(businessID).get();

        businessInfo = BusinessModel(
          businessId: temp.id,
          posLocations: temp.data()!['pos_locations']??[],
          businessName: temp.data()!['business_name'],
          businessLogo: temp.data()!['business_logo'] ?? "",
          adminEmail: temp.data()!['email'],
          businessAddress: temp.data()!['location'],
          contactNumber: temp.data()!['contact_number'],
          businessType: temp.data()!['business_type'],
          businessDescription: temp.data()!['description'],
          accounts: temp.data()!['accounts'],
        );
        user!.access = businessInfo!.accounts[user!.email];
        if (user!.access != "admin") {
          setIndex(2);
        } else {
          setIndex(0);
        }
        notifyListeners();
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  fetchUser(BuildContext context) async {
    if (user == null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> temp = await _firestore
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        print(temp.data());
        Provider.of<AccountingProvider>(context, listen: false)
            .fetchTransactions(temp.data()!['business_id']);

        Provider.of<InventoryProvider>(context, listen: false)
            .fetchProducts(temp.data()!['business_id']);
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchCustomers(temp.data()!['business_id']);
        Provider.of<SupplierProvider>(context, listen: false)
            .fetchSuppliers(temp.data()!['business_id']);
        user = LuminUser(
          id: temp.id,
          email: temp.data()!['email'],
          name: temp.data()!['name'],
          businessId: temp.data()!['business_id'],
        );

        await fetchBusiness(user!.businessId);
      } on Exception catch (e) {
        print(e);
      }

      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    index = null;
    user = null;
    businessInfo = null;
    notifyListeners();
  }
}
