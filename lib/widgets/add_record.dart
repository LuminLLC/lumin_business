import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/category.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
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
  bool isUpdating = false;
  var uuid = Uuid();
  final SizeAndSpacing sp = SizeAndSpacing();
  List<DateTime> date = [];
  String? selectedTransactionType;
  ProductCategory? selectedProductCategory;
  String? amountError;
  String? nameError;
  String? transactionTypeError;
  final List<String> items = ["Income", 'Expense'];
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
  String? priceError;

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
    dateController = TextEditingController()
      ..text = LuminUtll.formatDate(DateTime.now());
  }

  bool validateTransaction() {
    bool amountPass = true;
    bool typePass = true;
    bool datePass = true;

    if (amountController.text.isEmpty || amountController.text == "GHS  0.00") {
      amountPass = false;
      setState(() {
        amountError = "Amount can't be empty";
      });
    }

    if (selectedTransactionType == null) {
      setState(() {
        transactionTypeError = "Transaction type can't be empty";
      });
      typePass = false;
    }

    if (dateController.text.isEmpty) {
      setState(() {
        transactionTypeError = "Date";
      });
      typePass = false;
    }

    return amountPass && typePass && datePass;
  }

  bool validateProduct() {
    bool namePass = true;
    bool categoryPass = true;
    bool quantityPass = true;
    bool pricePass = true;

    if (priceController.text.isEmpty || priceController.text == "GHS  0.00") {
      pricePass = false;
      setState(() {
        priceError = "Price can't be zero";
      });
    }

    if (amountController.text.isEmpty || amountController.text == "0") {
      setState(() {
        amountError = "Quantity can't be zero";
      });
      quantityPass = false;
    }

    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Name can't be empty";
      });
      namePass = false;
    }

    if (selectedProductCategory == null) {
      setState(() {
        transactionTypeError = "Category can't be empty";
      });
      categoryPass = false;
    }

    return namePass && categoryPass && quantityPass && pricePass;
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
            height: isUpdating ? sp.getHeight(400, height, width) : null,
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
            isUpdating
                ? SizedBox()
                : LuminTextIconButton(
                    text: "Add",
                    icon: Icons.add,
                    onPressed: () => _handleSave(
                        provider, appState.businessInfo!.businessId),
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
        inputFormatters: [CurrencyInputFormatter(currencySymbol: "GHS ")],
        onChanged: (value) {
          if (amountError != null) {
            setState(() {
              amountError = null;
            });
          }
        },
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          errorText: amountError,
          labelText: "Transaction Amount",
          border: OutlineInputBorder(),
          hintText: "Enter the transaction amount",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      DropdownButtonFormField<String>(
        hint: Text(
          "Select a transaction type",
          style: TextStyle(
            color: Colors.grey[300], // Adjust this color to match your style
          ),
        ),
        value: selectedTransactionType,
        decoration: InputDecoration(
          errorText: transactionTypeError,
          // hintText: "Select a transaction type",
          // labelText: "Transaction Type",
          hintStyle: TextStyle(
            color: Colors.grey[300], // Adjust this color to match your style
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
            borderSide: BorderSide(
              color: Colors.grey, // Border color
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            borderSide: BorderSide(
              color: Colors.blue, // Border color when focused
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.only(
            left: 12.0, // Horizontal padding inside the dropdown
          ),
        ),
        icon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_drop_down, // Icon for the dropdown
            color: Colors.grey[700], // Adjust this color to match your style
          ),
        ),
        style: TextStyle(
          color: Colors.white, // Text color inside the dropdown
          fontSize: 16.0, // Text size inside the dropdown
        ),
        onChanged: (value) {
          if (transactionTypeError != null) {
            setState(() {
              transactionTypeError = null;
            });
          }
          setState(() {
            selectedTransactionType = value;
          });
        },
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
          child: Row(
            children: [
              Text(
                dateController.text,
                style: TextStyle(
                  color:
                      Colors.grey, // Adjust the text color to match your theme
                  fontSize: 16.0,
                ),
              ),
              Spacer(),
              Text(
                "Tap to change date",
                style: TextStyle(fontSize: 12, color: Colors.white30),
              )
            ],
          ),
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: descriptionController,
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
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Product Name",
          errorText: nameError,
          border: OutlineInputBorder(),
          hintText: "Enter the name of your product",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      Consumer<InventoryProvider>(builder: (context, inventoryProvider, _) {
        List<ProductCategory> categories = inventoryProvider.categories;
        return DropdownButtonFormField<ProductCategory>(
          hint: Text(
            "Select product category",
            style: TextStyle(
              color: Colors.grey[300], // Adjust this color to match your style
            ),
          ),
          value: selectedProductCategory,
          decoration: InputDecoration(
            errorText: transactionTypeError,
            // hintText: "Select a transaction type",
            // labelText: "Transaction Type",
            hintStyle: TextStyle(
              color: Colors.grey[300], // Adjust this color to match your style
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
              borderSide: BorderSide(
                color: Colors.grey, // Border color
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0), // Rounded corners
              borderSide: BorderSide(
                color: Colors.blue, // Border color when focused
                width: 2.0,
              ),
            ),
            contentPadding: EdgeInsets.only(
              left: 12.0, // Horizontal padding inside the dropdown
            ),
          ),
          icon: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_drop_down, // Icon for the dropdown
              color: Colors.grey[700], // Adjust this color to match your style
            ),
          ),
          style: TextStyle(
            color: Colors.white, // Text color inside the dropdown
            fontSize: 16.0, // Text size inside the dropdown
          ),
          onChanged: (value) {
            if (transactionTypeError != null) {
              setState(() {
                transactionTypeError = null;
              });
            }
            setState(() {
              selectedProductCategory = value;
            });
          },
          items: categories
              .map<DropdownMenuItem<ProductCategory>>((ProductCategory value) {
            return DropdownMenuItem<ProductCategory>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        );
      }),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: amountController,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        onChanged: (value) {
          if (amountError != null) {
            setState(() {
              amountError = null;
            });
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Quantity",
          errorText: amountError,
          border: OutlineInputBorder(),
          hintText: "Enter the product quantity",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: priceController,
        inputFormatters: [CurrencyInputFormatter(currencySymbol: "GHS ")],
        onChanged: (value) {
          if (priceError != null) {
            setState(() {
              priceError = null;
            });
          }
        },
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          errorText: priceError,
          labelText: "Unit Price",
          border: OutlineInputBorder(),
          hintText: "Enter the unit price",
        ),
      ),
    ];
  }

  List<Widget> _getCustomerFields(double width, double height) {
    return [
      TextField(
        controller: customerController,
        // onChanged: (value) => setState(() {
        //   hasChanges = true;
        // }),
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
        // onChanged: (value) => setState(() {
        //   hasChanges = true;
        // }),
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

  void resetControllers() {
    nameController.clear();
    categoryController.clear();
    quantityController.clear();
    priceController.clear();
    amountController.clear();
    customerController.clear();
    supplierController.clear();
    descriptionController.clear();
    selectedTransactionType = null;
    dateController = TextEditingController()
      ..text = LuminUtll.formatDate(DateTime.now());
  }

  Future<void> _handleSave(provider, String businessId) async {
    switch (widget.recordType) {
      case RecordType.transaction:
        bool isValid = validateTransaction();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final accountingProvider = provider as AccountingProvider;
          await accountingProvider.addTransaction(
            TransactionModel(
              id: uuid.v1(),
              description: descriptionController.text,
              amount: CurrencyInputFormatter().getAmount(amountController.text),
              date: dateController.text,
              type: TransactionType.income,
            ),
            businessId,
          );
          resetControllers();
          setState(() {
            isUpdating = false;
          });
        }

        break;
      case RecordType.product:
        bool isValid = validateProduct();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final inventoryProvider = provider as InventoryProvider;
          await inventoryProvider.addProduct(
              ProductModel(
                id: "id",
                name: nameController.text,
                quantity: int.tryParse(amountController.text) ?? 0,
                category: selectedProductCategory!.name,
                unitPrice:
                    CurrencyInputFormatter().getAmount(priceController.text),
              ),
              businessId,
              selectedProductCategory!.code);
          resetControllers();
          setState(() {
            isUpdating = false;
          });
        }
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
