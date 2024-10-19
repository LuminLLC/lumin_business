import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';

List<AccountingModel> dummyTransactionData = [
  AccountingModel(
      id: "1",
      description: "Sale of laptop",
      amount: 1200.0,
      date: "12th October 2024",
      type: TransactionType.income),
  AccountingModel(
      id: "2",
      description: "Purchase of 50 office chairs",
      amount: 3750.0,
      date: "12th October 2024",
      type: TransactionType.expense),
  AccountingModel(
      id: "3",
      description: "Sale of smartphone",
      amount: 800.0,
      date: "12th October 2024",
      type: TransactionType.income),
  AccountingModel(
      id: "4",
      description: "Purchase of 100 units of coffee makers",
      amount: 5000.0,
      date: "15th October 2024",
      type: TransactionType.expense),
  AccountingModel(
      id: "5",
      description: "Sale of running shoes",
      amount: 2500.0,
      date: "18th October 2024",
      type: TransactionType.income),
  AccountingModel(
      id: "6",
      description: "Purchase of 25 blenders",
      amount: 1125.0,
      date: "19th October 2024",
      type: TransactionType.expense),
];

class AccountingProvider with ChangeNotifier {
  String? photo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isAccountingFetched = true;
  String? newTransactionType;
  List<AccountingModel> allTransactions = dummyTransactionData;
  List<String> transactionHeaders = [
    "ID",
    "Description",
    "Amount",
    "Date",
    "Type",
    "Sale ID",
    "Purchase Order ID"
  ];

  void clearData() {
    isAccountingFetched = false;
    allTransactions = [];
    notifyListeners();
  }

  void uploadTransactionsFromCSV() async {
    try {
      List<AccountingModel> transactions =
          await CSVModule.uploadFromCSV<AccountingModel>(
        transactionHeaders,
        (rowMap) => AccountingModel.fromMap(rowMap),
      );
      print(transactions.length);
      // allTransactions = transactions;
      // notifyListeners();
    } catch (e) {
      print("Error uploading transactions: $e");
    }
  }

  double get netIncome {
    double netIncome = 0;
    if (allTransactions.isEmpty) {
      return netIncome;
    } else {
      for (AccountingModel transaction in allTransactions) {
        if (transaction.type == TransactionType.income) {
          netIncome += transaction.amount;
        } else {
          netIncome -= transaction.amount;
        }
      }
    }
    return netIncome;
  }

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

  List<String> getLastSevenWeekdays() {
    DateTime today = DateTime.now();
    List<String> weekdays = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = today.subtract(Duration(days: i));
      weekdays.add(weekdayToString(day.weekday));
    }

    return weekdays.reversed.toList();
  }

  String weekdayToString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  bool isWithinLastSevenDays(DateTime date) {
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 6));

    // Remove time part from the dates for accurate day comparison
    DateTime startOfToday = DateTime(today.year, today.month, today.day);
    DateTime startOfSevenDaysAgo =
        DateTime(sevenDaysAgo.year, sevenDaysAgo.month, sevenDaysAgo.day);
    DateTime startOfGivenDate = DateTime(date.year, date.month, date.day);

    return startOfGivenDate.isAfter(startOfSevenDaysAgo) &&
        startOfGivenDate.isBefore(startOfToday.add(Duration(days: 1)));
  }

  Map<String, double> get lastSevenDaysTransactions {
    Map<String, double> lastSevenDaysTransactions = {};
    for (AccountingModel t in allTransactions) {
      DateTime date =
          DateTime.tryParse(t.date) ?? LuminUtll.parseCustomDate(t.date);
      if (isWithinLastSevenDays(date)) {
        String weekday = weekdayToString(date.weekday);
        if (t.type == TransactionType.income) {
          lastSevenDaysTransactions[weekday] =
              (lastSevenDaysTransactions[weekday] ?? 0) + t.amount;
        } else {
          lastSevenDaysTransactions[weekday] =
              (lastSevenDaysTransactions[weekday] ?? 0) - t.amount;
        }
      }
    }

    return lastSevenDaysTransactions;
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
    print(getLastSevenWeekdays());
  }

  void setNewTransactionType(String s) {
    newTransactionType = s;
    notifyListeners();
  }
}
