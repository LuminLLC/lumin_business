import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/category.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
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
  late TextEditingController costController;
  late TextEditingController amountController;
  late TextEditingController descriptionController;
  late TextEditingController customerController;
  late TextEditingController addressController;
  late TextEditingController supplierController;
  late TextEditingController dateController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  String categoryCode = "";
  String? priceError;
  String? costError;
  String? addressError;
  String? phoneError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    categoryController = TextEditingController();
    quantityController = TextEditingController();
    priceController = TextEditingController();
    costController = TextEditingController();
    amountController = TextEditingController();
    customerController = TextEditingController();
    supplierController = TextEditingController();
    descriptionController = TextEditingController();
    addressController = TextEditingController();
    dateController = TextEditingController()
      ..text = LuminUtll.formatDate(DateTime.now());
    emailController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    quantityController.dispose();
    priceController.dispose();
    amountController.dispose();
    costController.dispose();
    customerController.dispose();
    supplierController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    dateController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void resetControllers() {
    nameController.clear();
    categoryController.clear();
    quantityController.clear();
    priceController.clear();
    costController.clear();
    amountController.clear();
    customerController.clear();
    supplierController.clear();
    descriptionController.clear();
    addressController.clear();
    dateController = TextEditingController()
      ..text = LuminUtll.formatDate(DateTime.now());
    emailController.clear();
    phoneNumberController.clear();
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
    bool costPass = true;

    if (priceController.text.isEmpty || priceController.text == "GHS  0.00") {
      pricePass = false;
      setState(() {
        priceError = "Price can't be zero";
      });
    }

    if (costController.text.isEmpty) {
      costController.text = "0";
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

    return namePass && categoryPass && quantityPass && pricePass && costPass;
  }

  bool validateCustomer() {
    bool namePass = true;
    bool addressPass = true;
    bool emailPass = true;
    bool phonePass = true;

    if (customerController.text.isEmpty) {
      setState(() {
        nameError = "Name can't be empty";
      });
      namePass = false;
    }

    if (addressController.text.isEmpty) {
      setState(() {
        addressError = "Address can't be empty";
      });
      addressPass = false;
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email can't be empty";
      });
      emailPass = false;
    }

    if (phoneNumberController.text.isEmpty) {
      setState(() {
        phoneError = "Phone can't be empty";
      });
      phonePass = false;
    }

    return namePass && addressPass && emailPass && phonePass;
  }

  bool validateSupplier() {
    bool namePass = true;
    bool addressPass = true;
    bool emailPass = true;
    bool phonePass = true;

    if (customerController.text.isEmpty) {
      setState(() {
        nameError = "Name can't be empty";
      });
      namePass = false;
    }

    if (addressController.text.isEmpty) {
      setState(() {
        addressError = "Address can't be empty";
      });
      addressPass = false;
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email can't be empty";
      });
      emailPass = false;
    }

    if (phoneNumberController.text.isEmpty) {
      setState(() {
        phoneError = "Phone can't be empty";
      });
      phonePass = false;
    }

    return namePass && addressPass && emailPass && phonePass;
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
                    primary: false,
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
                    text: "Add ${widget.recordType.name}",
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
          print(value);
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
            config: CalendarDatePicker2WithActionButtonsConfig(
             lastDate: DateTime.now()
            ),
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
        controller: costController,
        inputFormatters: [CurrencyInputFormatter(currencySymbol: "GHS ")],
        onChanged: (value) {
          if (costError != null) {
            setState(() {
              costError = null;
            });
          }
        },
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          errorText: costError,
          labelText: "Unit Cost",
          border: OutlineInputBorder(),
          hintText: "Enter the unit cost",
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
        onChanged: (value) {
          if (nameError != null) {
            setState(() {
              nameError = null;
            });
          }
        },
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Customer Name",
          errorText: nameError,
          border: OutlineInputBorder(),
          hintText: "Enter the name of the customer",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: addressController,
        onChanged: (value) {
          if (addressError != null) {
            setState(() {
              addressError = null;
            });
          }
        },
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Customer Address",
          errorText: addressError,
          border: OutlineInputBorder(),
          hintText: "Enter the customer's address",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: emailController,
        onChanged: (value) {
          if (emailError != null) {
            setState(() {
              emailError = null;
            });
          }
        },
        inputFormatters: [EmailInputFormatter()],
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Customer Email",
          errorText: emailError,
          border: OutlineInputBorder(),
          hintText: "Enter the customer's email",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: phoneNumberController,
        onChanged: (value) {
          if (phoneError != null) {
            setState(() {
              phoneError = null;
            });
          }
        },
        inputFormatters: [PhoneNumberInputFormatter()],
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Customer Phone Number",
          errorText: phoneError,
          border: OutlineInputBorder(),
          hintText: "Enter the customer's phone number",
        ),
      ),
    ];
  }

  List<Widget> _getSupplierFields(double width, double height) {
    return [
      TextField(
        controller: customerController,
        onChanged: (value) {
          if (nameError != null) {
            setState(() {
              nameError = null;
            });
          }
        },
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Supplier Name",
          errorText: nameError,
          border: OutlineInputBorder(),
          hintText: "Enter the name of the supplier",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: addressController,
        onChanged: (value) {
          if (addressError != null) {
            setState(() {
              addressError = null;
            });
          }
        },
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Supplier Address",
          errorText: addressError,
          border: OutlineInputBorder(),
          hintText: "Enter the supplier's address",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: emailController,
        onChanged: (value) {
          if (emailError != null) {
            setState(() {
              emailError = null;
            });
          }
        },
        inputFormatters: [EmailInputFormatter()],
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Supplier Email",
          errorText: emailError,
          border: OutlineInputBorder(),
          hintText: "Enter the supplier's email",
        ),
      ),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      TextField(
        controller: phoneNumberController,
        onChanged: (value) {
          if (phoneError != null) {
            setState(() {
              phoneError = null;
            });
          }
        },
        inputFormatters: [PhoneNumberInputFormatter()],
        keyboardType: TextInputType.phone,
        style: TextStyle(fontSize: sp.getFontSize(16, width)),
        decoration: InputDecoration(
          labelText: "Supplier Phone Number",
          errorText: phoneError,
          border: OutlineInputBorder(),
          hintText: "Enter the supplier's phone number",
        ),
      ),
    ];
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
            AccountingModel(
              id: uuid.v1(),
              description: descriptionController.text,
              amount: CurrencyInputFormatter().getAmount(amountController.text),
              date: dateController.text,
              type: selectedTransactionType == "Income"
                  ? TransactionType.income
                  : TransactionType.expense,
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
                description: "",
                quantity: int.tryParse(amountController.text) ?? 0,
                category: selectedProductCategory!.name,
                unitPrice:
                    CurrencyInputFormatter().getAmount(priceController.text),
                unitCost:
                    CurrencyInputFormatter().getAmount(costController.text),
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
        bool isValid = validateCustomer();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final customerProvider = provider as CustomerProvider;
          await customerProvider.addCustomer(
            CustomerModel(
                id: uuid.v1(),
                name: customerController.text,
                address: addressController.text,
                email: emailController.text,
                phoneNumber: phoneNumberController.text,
                orders: []),
            businessId,
          );
          resetControllers();
          setState(() {
            isUpdating = false;
          });
        }
        break;
      case RecordType.supplier:
        bool isValid = validateSupplier();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final supplierProvider = provider as SupplierProvider;
          await supplierProvider.addSupplier(
            SupplierModel(
                id: uuid.v1(),
                name: customerController.text,
                address: addressController.text,
                email: emailController.text,
                contactNumber: phoneNumberController.text,
                orders: [],
                products: []),
            businessId,
          );
          resetControllers();
          setState(() {
            isUpdating = false;
          });
        }
        break;
    }
  }
}
