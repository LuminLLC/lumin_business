import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
 
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewCustomer extends StatefulWidget {
  final AppState appState;

  const NewCustomer({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  State<NewCustomer> createState() => _NewCustomerState();
}

class _NewCustomerState extends State<NewCustomer> {
  var uuid = Uuid();
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late TextEditingController dateController;
  String catehoryCode = "";
  bool hasChanges = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    descriptionController = TextEditingController();
    amountController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Consumer2<CustomerProvider, AppState>(
        builder: (context, customerProvider, appState, _) {
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
              // child: customerProvider.newTransactionType == null
              //     ? null
              //     : Icon(customerProvider.newTransactionType == "Income"
              //         ? Icons.south_west
              //         : Icons.north_east),
            ),
            SizedBox(
              width: sp.getWidth(20, width),
            ),
            Text(
              "Add New Customer",
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
                        controller: descriptionController,
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
                      // DropdownButtonFormField<String>(
                      //   value: customerProvider.newTransactionType,
                      //   onChanged: (newValue) {
                      //     print(newValue);
                      //   },
                      //   decoration: InputDecoration(
                      //     labelText: "Transaction Type",
                      //     border: OutlineInputBorder(),
                      //     hintText: "Select a transaction type",
                      //   ),
                      //   items: ["Income", "Expense"]
                      //       .map<DropdownMenuItem<String>>((String value) {
                      //     return DropdownMenuItem<String>(
                      //       value: value,
                      //       child: Text(value),
                      //     );
                      //   }).toList(),
                      // ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                      //date
                      TextField(
                        controller: dateController..text = LuminUtll.formatDate(DateTime.now()),
                        
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
                            onPressed: () {
                              DatePickerDialog(
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now(),
                              );
                            },
                          ),
                          border: OutlineInputBorder(),

                          // hintText: widget.product.quantity.toString()
                        ),
                      ),
                      SizedBox(
                        height: sp.getHeight(35, width, height),
                      ),
                      //amount
                      TextField(
                        controller: amountController,
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
                customerProvider.addCustomer(
                    CustomerModel(
                        id: uuid.v1(),
                        name: "John Doe",
                        address: "123 Apple Street, Any Town",
                        email: "stan@luminllc.com",
                        phoneNumber: "phoneNumber",
                        orders: []),
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
