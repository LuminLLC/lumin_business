import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/util.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewTransaction extends StatefulWidget {
  final AppState appState;

  const NewTransaction({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  var uuid = Uuid();
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  String catehoryCode = "";
  bool hasChanges = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    quantityController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Consumer2<AccountingProvider, AppState>(
        builder: (context, accountingProvider, appState, _) {
      return AlertDialog(
        title: Row(
          children: [
            Container(
              height: sp.getWidth(100, width),
              width: sp.getWidth(100, width),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: accountingProvider.newTransactionType == null
                  ? null
                  : Icon(accountingProvider.newTransactionType == "Income"
                      ? Icons.south_west
                      : Icons.north_east),
            ),
            SizedBox(
              width: sp.getWidth(20, width),
            ),
            Text(
              "Add New Transaction",
              style: TextStyle(fontSize: sp.getFontSize(24, width)),
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
                        maxLines: 3,
                        maxLength: 100,
                        onChanged: (value) {
                          if (!hasChanges) {
                            setState(() {
                              hasChanges = true;
                            });
                          }
                        },
                        style: TextStyle(fontSize: sp.getFontSize(16, width)),
                        decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(),
                          // hintText: widget.product.name
                        ),
                      ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                      DropdownButtonFormField<String>(
                        value: accountingProvider.newTransactionType,
                        onChanged: (newValue) {
                          print(newValue);
                        },
                        decoration: InputDecoration(
                          labelText: "Transaction Type",
                          border: OutlineInputBorder(),
                          hintText: "Select a transaction type",
                        ),
                        items: ["Income", "Expense"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                      TextField(
                        controller: quantityController
                          ..text = LuminUtil.formatDate(DateTime.now()),
                        style: TextStyle(fontSize: sp.getFontSize(16, width)),
                        keyboardType: TextInputType.datetime,
                        onChanged: (value) {
                          if (!hasChanges) {
                            setState(() {
                              hasChanges = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          // enabled: widget.appState.user!.access == "admin",
                          labelText: "Date",
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(),
                          // hintText: widget.product.quantity.toString()
                        ),
                      ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                      TextField(
                        controller: priceController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        onChanged: (value) {
                          // if (priceErr != null) {
                          //   setState(() {
                          //     unitPriceError = null;
                          //   });
                          // }
                        },
                        style: TextStyle(fontSize: sp.getFontSize(16, width)),
                        decoration: InputDecoration(
                            prefix: Text("GHS "),
                            labelText: "Amount",
                            border: OutlineInputBorder(),
                            hintText: "Enter transaction amount"),
                      ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                    ],
                  ),
                ),
        ),
        actions: [
          LuminTextIconButton(
            text: hasChanges ? "Save & Exit" : "Close",
            icon: hasChanges ? Icons.save : Icons.close,
            onPressed: () async {
              if (hasChanges) {
                accountingProvider.addTransaction(
                    TransactionModel(
                        id: uuid.v1(),
                        description: "Saint test",
                        amount: 20,
                        date: DateTime.now(),
                        type: TransactionType.income),
                    appState.businessInfo!.businessId);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    });
  }
}
