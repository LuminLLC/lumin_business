import 'package:flutter/material.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';

List<TransactionModel> dummyProductData = [
  TransactionModel(
      id: "id",
      description: "Sale of book",
      amount: 100,
      date: DateTime.now(),
      type: TransactionType.income),
  TransactionModel(
      id: "id",
      description: "Purchase 100 boxes of books",
      amount: 100,
      date: DateTime.now(),
      type: TransactionType.expense),
  TransactionModel(
      id: "id",
      description: "Sale of pens",
      amount: 100,
      date: DateTime.now(),
      type: TransactionType.income),
  TransactionModel(
      id: "id",
      description: "Purchase of store electricity",
      amount: 100,
      date: DateTime.now(),
      type: TransactionType.expense),
];

class AccountingProvider with ChangeNotifier {
  bool isAccountingFetched = true;
  List<TransactionModel> allTransactions = dummyProductData; //[];
}
