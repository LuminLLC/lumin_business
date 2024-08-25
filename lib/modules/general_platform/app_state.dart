import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/user_and_busness/business_model.dart';
import 'package:lumin_business/modules/user_and_busness/lumin_user.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  String searchText = "";
  BusinessModel? businessInfo;
  LuminUser? user;
  int index = 0;

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
          businessName: temp.data()!['business_name'],
          businessLogo: temp.data()!['business_logo'] ?? "",
          adminEmail: temp.data()!['email'],
          businessAddress: temp.data()!['location'],
          contactNumber: temp.data()!['contact_number'],
          businessType: temp.data()!['business_type'],
          businessDescription: temp.data()!['description'],
          accounts: temp.data()!['accounts'],
        );

        print({businessInfo!.accounts});
        user!.access = businessInfo!.accounts[user!.email];
        notifyListeners();
      } catch (e) {}
    }
  }

  fetchUser(BuildContext context) async {
    if (user == null) {
      print("fetch user");
      DocumentSnapshot<Map<String, dynamic>> temp = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Provider.of<InventoryProvider>(context, listen: false)
          .fetchProducts(temp.data()!['business_id']);
      user = LuminUser(
        id: temp.id,
        email: temp.data()!['email'],
        name: temp.data()!['name'],
        businessId: temp.data()!['business_id'],
      );

      fetchBusiness(user!.businessId);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    index = 0;
    user = null;
    businessInfo = null;
    notifyListeners();
  }
}
