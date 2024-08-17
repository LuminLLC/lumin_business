import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';

// List<TransactionModel> dummyProductData = [
//   TransactionModel(
//       id: "id",
//       description: "Sale of book",
//       amount: 100,
//       date: DateTime.now(),
//       type: TransactionType.income),
//   TransactionModel(
//       id: "id",
//       description: "Purchase 100 boxes of books",
//       amount: 100,
//       date: DateTime.now(),
//       type: TransactionType.expense),
//   TransactionModel(
//       id: "id",
//       description: "Sale of pens",
//       amount: 100,
//       date: DateTime.now(),
//       type: TransactionType.income),
//   TransactionModel(
//       id: "id",
//       description: "Purchase of store electricity",
//       amount: 100,
//       date: DateTime.now(),
//       type: TransactionType.expense),
// ];

class AccountingProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isAccountingFetched = false;
  String? newTransactionType;
  List<TransactionModel> allTransactions = [];

  Future<void> addTransaction(TransactionModel t, String businessID) async {
    try {
      await _firestore
          .collection("businesses")
          .doc(businessID)
          .collection("accounts")
          .doc(t.id)
          .set(t.toMap());
      allTransactions.add(t);
      allTransactions.sort((a, b) => a.date.compareTo(b.date));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchTransactions(String businessID) async {
    if (!isAccountingFetched) {
      try {
        QuerySnapshot<Map<String, dynamic>> rawDocs = await _firestore
            .collection("businesses")
            .doc(businessID)
            .collection("accounts")
            .get();
        for (var v in rawDocs.docs) {
          allTransactions.add(TransactionModel.fromMap(v.data()));
        }
        allTransactions.sort((a, b) => a.date.compareTo(b.date));
        isAccountingFetched = true;
        notifyListeners();
      } catch (e) {
        print("error fetching transactions");
      }
    }
  }

  void setNewTransactionType(String s) {
    newTransactionType = s;
    notifyListeners();
  }
}
