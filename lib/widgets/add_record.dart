import 'package:flutter/material.dart';
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
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late TextEditingController amountController;
  late TextEditingController customerController;
  late TextEditingController supplierController;
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
      // Add transaction-specific fields here
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
