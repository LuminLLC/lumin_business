import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:lumin_business/models/business.dart';
import 'package:lumin_business/models/lumin_user.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Business? businessInfo;
  LuminUser? user;
  int index = 0;

  void setIndex(int i) {
    if (index != i) {
      index = i;
      notifyListeners();
    }
  }

  Future<void> fetchBusiness(String businessID) async {
    DocumentSnapshot<Map<String, dynamic>> temp =
        await _firestore.collection('businesses').doc(businessID).get();

    businessInfo = Business(
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
    print(businessInfo!.accounts);
    user!.access = businessInfo!.accounts[user!.email];
    notifyListeners();
  }

  fetchUser(BuildContext context) async {
    DocumentSnapshot<Map<String, dynamic>> temp = await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    Provider.of<ProductController>(context, listen: false)
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

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    user = null;
    businessInfo = null;
    notifyListeners();
  }
}
