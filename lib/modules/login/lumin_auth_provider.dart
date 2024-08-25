import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LuminAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<dynamic> emailSignIn(String emailAddress, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: emailAddress, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return "Sign in error: ${e.message}";
    }
  }

  Future<dynamic> createUserWithEmail(
      String name, String emailAddress, String password) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
              email: emailAddress, password: password);
      String businessID = await _createNewBusiness(credential.user!);
      await _createNewUser(name, credential.user!, businessID);

      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      }
      return 'Sign up error: ${e.message}';
    }
  }

  Future<void> _createNewUser(String name, User user, String businessID) async {
    try {
      // Create a new business document with an empty structure
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'name': name,
        'business_id': businessID,
      });
    } catch (e) {
      print("Error creating business: $e");
    }
  }

  Future<String> _createNewBusiness(User user) async {
    try {
      // Create a new business document with an empty structure
      DocumentReference businessRef =
          await _firestore.collection('businesses').add({
        'accounts': {user.email!: 'admin'},
        'business_name': '',
        'business_type': '',
        'contact_number': '',
        'description': '',
        'ref':'',
        'email': user.email,
        'location': '',
      });

      return businessRef.id;
    } catch (e) {
      print("Error creating business: $e");
      return "";
    }
  }
}
