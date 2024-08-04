import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';

class SelectedTransaction extends StatefulWidget {
  final TransactionModel transaction;
  final AppState appState;
  final AccountingProvider accountingProvider;
  const SelectedTransaction(
      {Key? key,
      required this.transaction,
      required this.appState,
      required this.accountingProvider})
      : super(key: key);

  @override
  State<SelectedTransaction> createState() => _SelectedTransactionState();
}

class _SelectedTransactionState extends State<SelectedTransaction> {
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  bool hasChanges = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController()
      ..text = widget.transaction.description;
    categoryController = TextEditingController()
      ..text = widget.transaction.type.toString();
    quantityController = TextEditingController()
      ..text = widget.transaction.amount.toString();
    priceController = TextEditingController()
      ..text = widget.transaction.date.toIso8601String();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Row(
        children: [
          Container(
            height: sp.getWidth(50, width),
            width: sp.getWidth(50, width),
            decoration: BoxDecoration(
              color: widget.transaction.type == TransactionType.income
                  ? Colors.green
                  : Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Icon(widget.transaction.type == TransactionType.income
                ? Icons.south_west
                : Icons.north_east),
          ),
          SizedBox(
            width: sp.getWidth(20, width),
          ),
          Text(
            "Transaction Details",
            style: TextStyle(fontSize: sp.getFontSize(24, width)),
          ),
          SizedBox(width: sp.getWidth(20, width)),
          widget.appState.user!.access == "admin"
              ? IconButton(onPressed: () {}, icon: Icon(Icons.copy))
              : Text(
                  "(${widget.transaction.id})",
                  style: TextStyle(fontSize: sp.getFontSize(16, width)),
                ),
        ],
      ),
      content: SizedBox(
        width: sp.getWidth(600, width),
        child: isUpdating
            ? Center(
                child: SizedBox(
                    height: sp.getWidth(50, width),
                    width: sp.getWidth(50, width),
                    child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: nameController,
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: "Description",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: categoryController,
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      decoration: InputDecoration(
                        labelText: "Transaction Type",
                        enabled: false,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: quantityController,
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      decoration: InputDecoration(
                        enabled: false,
                        labelText: "Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: priceController,
                      enabled: false,
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      decoration: InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
