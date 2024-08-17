import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum RecordType {
  transaction,
  product,
  customer,
  supplier,
}

class AddRecord<T extends ChangeNotifier> extends StatefulWidget {
  final RecordType recordType;
  const AddRecord({
    Key? key,
    required this.recordType,
  }) : super(key: key);

  @override
  State<AddRecord<T>> createState() => _AddRecordState<T>();
}

class _AddRecordState<T extends ChangeNotifier> extends State<AddRecord<T>> {
  var uuid = Uuid();
  final SizeAndSpacing sp = SizeAndSpacing();
  List<DateTime> date = [];
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late TextEditingController customerController;
  late TextEditingController supplierController;
  late TextEditingController dateController;
  String categoryCode = "";
  bool hasChanges = false;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    quantityController = TextEditingController();
    priceController = TextEditingController();
    amountController = TextEditingController();
    customerController = TextEditingController();
    supplierController = TextEditingController();
    descriptionController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final appState = Provider.of<AppState>(context);

    return Consumer<T>(
      builder: (context, provider, _) {
        return AlertDialog(
          title: Text(_getDialogTitle(widget.recordType)),
          content: SizedBox(
            width: sp.getWidth(600, width),
            child: isUpdating
                ? Center(
                    child: SizedBox(
                      height: sp.getWidth(50, width),
                      width: sp.getWidth(50, width),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          _getFormFields(widget.recordType, width, height),
                    ),
                  ),
          ),
          actions: [
            LuminTextIconButton(
              text: hasChanges ? "Save" : "Close",
              icon: hasChanges ? Icons.save : Icons.close,
              onPressed: () async {
                if (hasChanges) {
                  if (provider is AccountingProvider) {
                    setState(() {
                      isUpdating = true;
                    });
                    await _handleSave(
                        provider, appState.businessInfo!.businessId);
                    setState(() {
                      isUpdating = false;
                    });
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  String _getDialogTitle(RecordType recordType) {
    switch (recordType) {
      case RecordType.transaction:
        return "Add Transaction";
      case RecordType.product:
        return "Add Product";
      case RecordType.customer:
        return "Add Customer";
      case RecordType.supplier:
        return "Add Supplier";
      default:
        return "Add Record";
    }
  }

  List<Widget> _getFormFields(
      RecordType recordType, double width, double height) {
    switch (recordType) {
      case RecordType.transaction:
        return _getTransactionFields(width, height);
      case RecordType.product:
        return _getProductFields(width, height);
      case RecordType.customer:
        return _getCustomerFields(width, height);
      case RecordType.supplier:
        return _getSupplierFields(width, height);
      default:
        return [];
    }
  }

  List<Widget> _getTransactionFields(double width, double height) {
    return [
      TextField(
        controller: amountController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
            labelText: "Transaction Amount",
            border: OutlineInputBorder(),
            hintText: "Enter the transaction amount",
            prefix: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text("GHS"),
            )),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: descriptionController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
            labelText: "Transaction Type",
            border: OutlineInputBorder(),
            hintText: "Select the transaction type",
            prefix: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text("GHS"),
            )),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      InkWell(
        onTap: () async {
          await showCalendarDatePicker2Dialog(
            context: context,
            config: CalendarDatePicker2WithActionButtonsConfig(),
            dialogSize: const Size(325, 400),
            value: date,
            borderRadius: BorderRadius.circular(15),
          ).then((result) {
            if (result != null && result[0] != null) {
              setState(() {
                dateController.text = LuminUtll.formatDate(result[0]!);
              });
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Adjust the border color to match your theme
              width: 1.0,
            ),
            borderRadius:
                BorderRadius.circular(5.0), // Adjust the radius as needed
            color:
                Colors.transparent, // Match the background color to your theme
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ), //Add padding inside the container
          width: double.infinity,
          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              dateController.text.isEmpty
                  ? "Tap to select date"
                  : dateController.text,
              style: TextStyle(
                color: Colors.grey, // Adjust the text color to match your theme
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: descriptionController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        maxLines: 3,
        maxLength: 50,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Desctiption",
          border: OutlineInputBorder(),
          hintText: "Enter the transaction description",
        ),
      ),
    ];
  }

  List<Widget> _getProductFields(double width, double height) {
    return [
      TextField(
        controller: nameController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Product Name",
          border: OutlineInputBorder(),
          hintText: "Enter the name of your product",
        ),
      ),
      // Add more product-specific fields here
    ];
  }

  List<Widget> _getCustomerFields(double width, double height) {
    return [
      TextField(
        controller: customerController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Customer Name",
          border: OutlineInputBorder(),
          hintText: "Enter the name of the customer",
        ),
      ),
      // Add more customer-specific fields here
    ];
  }

  List<Widget> _getSupplierFields(double width, double height) {
    return [
      TextField(
        controller: supplierController,
        onChanged: (value) => setState(() {
          hasChanges = true;
        }),
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Supplier Name",
          border: OutlineInputBorder(),
          hintText: "Enter the name of the supplier",
        ),
      ),
      // Add more supplier-specific fields here
    ];
  }

  Future<void> _handleSave(
      AccountingProvider provider, String businessId) async {
    switch (widget.recordType) {
      case RecordType.transaction:
        await provider.addTransaction(
          TransactionModel(
            id: uuid.v1(),
            description: "",
            amount: double.parse(amountController.text),
            date: DateTime.now(),
            type: TransactionType.income,
          ),
          businessId,
        );
        break;
      case RecordType.product:
        // Handle saving product
        break;
      case RecordType.customer:
        // Handle saving customer
        break;
      case RecordType.supplier:
        // Handle saving supplier
        break;
    }
  }
}
