import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';

List<AccountingModel> dummyTransactionData = [
  AccountingModel(
      id: "1",
      description: "Sale of laptop",
      amount: 1200.0,
      date: "2024-08-01",
      type: TransactionType.income),
  AccountingModel(
      id: "2",
      description: "Purchase of 50 office chairs",
      amount: 3750.0,
      date: "2024-07-29",
      type: TransactionType.expense),
  AccountingModel(
      id: "3",
      description: "Sale of smartphone",
      amount: 800.0,
      date: "2024-07-25",
      type: TransactionType.income),
  AccountingModel(
      id: "4",
      description: "Purchase of 100 units of coffee makers",
      amount: 5000.0,
      date: "2024-08-05",
      type: TransactionType.expense),
  AccountingModel(
      id: "5",
      description: "Sale of running shoes",
      amount: 2500.0,
      date: "2024-07-30",
      type: TransactionType.income),
  AccountingModel(
      id: "6",
      description: "Purchase of 25 blenders",
      amount: 1125.0,
      date: "2024-07-27",
      type: TransactionType.expense),
  AccountingModel(
      id: "7",
      description: "Sale of wireless mouse",
      amount: 2500.0,
      date: "2024-08-03",
      type: TransactionType.income),
  AccountingModel(
      id: "8",
      description: "Purchase of 200 desk lamps",
      amount: 7000.0,
      date: "2024-08-06",
      type: TransactionType.expense),
  AccountingModel(
      id: "9",
      description: "Sale of gaming console",
      amount: 5000.0,
      date: "2024-08-02",
      type: TransactionType.income),
  AccountingModel(
      id: "10",
      description: "Purchase of 500 water bottles",
      amount: 6000.0,
      date: "2024-07-28",
      type: TransactionType.expense),
];

class AccountingProvider with ChangeNotifier {
  String? photo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isAccountingFetched = false;
  String? newTransactionType;
  List<AccountingModel> allTransactions = []; //dummyTransactionData;

  void downloadAccountingToCSV() {
    CSVModule.downloadToCSV<AccountingModel>(
        allTransactions,
        [
          "ID",
          "Description",
          "Amount",
          "Date",
          "Type",
          "Sale ID",
          "Purchase Order ID"
        ],
        (transaction) => [
              transaction.id,
              transaction.description,
              transaction.amount,
              transaction.date,
              transaction.type,
              transaction.saleID,
              transaction.purchaseOrderID
            ],
        "Transactions");
  }

  Future<void> addTransaction(AccountingModel t, String businessID) async {
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
          allTransactions.add(AccountingModel.fromMap(v.data()));
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
