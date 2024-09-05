import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/category.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:lumin_business/modules/suppliers/supply_order_model.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum RecordType {
  transaction,
  product,
  customer,
  supplier,
}

class ViewRecord<T extends ChangeNotifier> extends StatefulWidget {
  final RecordType recordType;
  final dynamic record;
  const ViewRecord({Key? key, required this.recordType, required this.record})
      : super(key: key);

  @override
  State<ViewRecord<T>> createState() => _ViewRecordState<T>();
}

class _ViewRecordState<T extends ChangeNotifier> extends State<ViewRecord<T>> {
  bool isUpdating = false;
  bool hasChanges = false;
  var uuid = Uuid();
  final SizeAndSpacing sp = SizeAndSpacing();
  List<DateTime> date = [];
  String? selectedTransactionType;
  ProductCategory? selectedProductCategory;
  List<ProductCategory>? categories;
  String? amountError;
  String? newCategory;
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
  late TextEditingController addressController;
  late TextEditingController supplierController;
  late TextEditingController dateController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController costController;
  String categoryCode = "";
  String? priceError;
  String? addressError;
  String? phoneError;
  String? emailError;
  String? costError;

  @override
  void initState() {
    super.initState();
    switch (widget.recordType) {
      case RecordType.product:
        final p = widget.record as ProductModel;
        nameController = TextEditingController(text: p.name);
        amountController = TextEditingController(text: p.quantity.toString());
        priceController =
            TextEditingController(text: LuminUtll.formatCurrency(p.unitPrice));
        costController =
            TextEditingController(text: LuminUtll.formatCurrency(p.unitCost));
        break;
      case RecordType.supplier:
        final s = widget.record as SupplierModel;
        customerController = TextEditingController(text: s.name);
        addressController = TextEditingController(text: s.address);
        emailController = TextEditingController(text: s.email);
        phoneNumberController = TextEditingController(text: s.contactNumber);
        break;
      case RecordType.customer:
        final c = widget.record as CustomerModel;
        customerController = TextEditingController(text: c.name);
        addressController = TextEditingController(text: c.address);
        emailController = TextEditingController(text: c.email);
        phoneNumberController = TextEditingController(text: c.phoneNumber);
        break;
      default:
    }
  }

  @override
  void dispose() {
    switch (widget.recordType) {
      case RecordType.product:
        nameController.dispose();
        amountController.dispose();
        priceController.dispose();
        costController.dispose();
        break;
      case RecordType.supplier:
        customerController.dispose();
        addressController.dispose();
        emailController.dispose();
        phoneNumberController.dispose();
        break;
      case RecordType.customer:
        customerController.dispose();
        addressController.dispose();
        emailController.dispose();
        phoneNumberController.dispose();
        break;
      default:
    }
    super.dispose();
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
      
      print(costController.text);
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

  // void isChanged() {
  //   switch (widget.recordType) {
  //     case RecordType.customer:
  //       final c = widget.record as CustomerModel;
  //       setState(() {
  //         // isUpdating = p.name == nameController.text &&
  //         //     p.quantity.toString() == amountController.text &&
  //         //     p.category == selectedProductCategory?.name &&
  //         //     p.unitPrice ==
  //         //         CurrencyInputFormatter().getAmount(priceController.text);
  //       });
  //       break;
  //     case RecordType.supplier:
  //       final s = widget.record as SupplierModel;
  //       setState(() {
  //         // isUpdating = p.name == nameController.text &&
  //         //     p.quantity.toString() == amountController.text &&
  //         //     p.category == selectedProductCategory?.name &&
  //         //     p.unitPrice ==
  //         //         CurrencyInputFormatter().getAmount(priceController.text);
  //       });
  //       break;
  //     case RecordType.product:
  //       final p = widget.record as ProductModel;
  //       setState(() {
  //         isUpdating = p.name == nameController.text &&
  //             p.quantity.toString() == amountController.text &&
  //             p.category == selectedProductCategory?.name &&
  //             p.unitPrice ==
  //                 CurrencyInputFormatter().getAmount(priceController.text);
  //       });
  //       break;
  //     default:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final appState = Provider.of<AppState>(context);

    return Consumer<T>(
      builder: (context, provider, _) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(_getDialogTitle(widget.recordType),
                      style: AppTextTheme().textTheme(width).headlineLarge),
                  Text(
                    widget.record.id,
                    style: AppTextTheme().textTheme(width).headlineMedium,
                  ),
                ],
              ),
              if (widget.recordType != RecordType.transaction)
                Padding(
                  padding: EdgeInsets.only(
                      top: sp.getHeight(5, height, width),
                      bottom: sp.getHeight(20, height, width)),
                  child: Text(
                    "Type in any of the fields to start editing",
                    style: AppTextTheme().textTheme(width).bodySmall,
                  ),
                )
            ],
          ),
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
            if (widget.recordType == RecordType.customer ||
                widget.recordType == RecordType.supplier)
              LuminTextIconButton(
                  text: widget.recordType == RecordType.supplier
                      ? "Order Products"
                      : "Create Custom Order",
                  icon: FontAwesomeIcons.firstOrder,
                  onPressed: () {}),
            if (widget.recordType != RecordType.transaction)
              isUpdating || !hasChanges
                  ? SizedBox()
                  : LuminTextIconButton(
                      text: "Update ${widget.recordType.name}",
                      icon: FontAwesomeIcons.floppyDisk,
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
        return "Transaction ID: ";
      case RecordType.product:
        return "Product ID: ";
      case RecordType.customer:
        return "Customer ID: ";
      case RecordType.supplier:
        return "Supplier ID: ";
      default:
        return "View Record";
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
    final t = widget.record as AccountingModel;
    return [
      Text("Amount: ${LuminUtll.formatCurrency(t.amount)}"),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      Text("Type: ${t.type.name}"),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      Text("Date: ${t.date}"),
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      if (t.description.isNotEmpty) Text("Description: ${t.description}"),
      if (t.purchaseOrderID != null)
        Text("Purchase Order ID: ${t.purchaseOrderID}"),
      if (t.saleID != null) Text("Sale ID: ${t.saleID}")
    ];
  }

  List<Widget> _getProductFields(double width, double height) {
    final p = widget.record as ProductModel;
    return [
      TextField(
        controller: nameController,
        onChanged: (value) {
          if (nameError != null) {
            setState(() {
              nameError = null;
            });
          }
          setState(() {
            hasChanges = !(value == p.name);
          });
        },
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
        selectedProductCategory = categories
            .toList()
            .singleWhere((category) => category.name == p.category);
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
              newCategory = value!.name;
              hasChanges = !(value.name == p.category);
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
          setState(() {
            hasChanges = !(value == p.quantity.toString());
          });
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
          setState(() {
            hasChanges =
                !(CurrencyInputFormatter().getAmount(value) == p.unitCost);
          });
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
          setState(() {
            hasChanges =
                !(CurrencyInputFormatter().getAmount(value) == p.unitPrice);
          });
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
    final c = widget.record as CustomerModel;
    return [
      TextField(
        controller: customerController,
        onChanged: (value) {
          if (nameError != null) {
            setState(() {
              nameError = null;
            });
          }
          setState(() {
            hasChanges = !(value == c.name);
          });
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
          setState(() {
            hasChanges = !(value == c.address);
          });
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
          setState(() {
            hasChanges = !(value == c.email);
          });
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
          print(c.phoneNumber);
          print(value);
          setState(() {
            hasChanges = !(value == c.phoneNumber);
          });
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
    final s = widget.record as SupplierModel;
    return [
      TextField(
        controller: customerController,
        onChanged: (value) {
          if (nameError != null) {
            setState(() {
              nameError = null;
            });
          }
          setState(() {
            hasChanges = !(value == s.name);
          });
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
          setState(() {
            hasChanges = !(value == s.address);
          });
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
        controller: emailController..text = s.email,
        onChanged: (value) {
          if (emailError != null) {
            setState(() {
              emailError = null;
            });
          }
          setState(() {
            hasChanges = !(value == s.email);
          });
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
          setState(() {
            hasChanges = !(value == s.contactNumber);
          });
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
      SizedBox(
        height: sp.getHeight(30, height, width),
      ),
      if (s.orders.isNotEmpty) Text("Orders"),
      if (s.orders.isNotEmpty)
        Padding(
          padding: EdgeInsets.only(right: width * 0.25),
          child: Divider(),
        ),
      if (s.orders.isNotEmpty)
        for (SupplyOrder order in s.orders)
          ExpansionTile(
            title: Text(
              "${order.orderId}",
            ),
            leading: Text(
              "${s.orders.indexOf(order) + 1}",
            ),
            trailing: Text(
              "${order.status.name}",
            ),
            expandedAlignment: Alignment.centerLeft,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: sp.getWidth(25, width),
                    bottom: sp.getHeight(10, height, width)),
                child: Text(
                  "Order Date: ${order.orderDate}",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sp.getWidth(25, width),
                    bottom: sp.getHeight(10, height, width)),
                child: Text(
                  "Delivery Date: ${order.deliveryDate}",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sp.getWidth(25, width),
                    bottom: sp.getHeight(10, height, width)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ordered Products:",
                    ),
                    for (String key in order.orderedProducts.keys)
                      ListTile(
                        leading: Text(
                            "${order.orderedProducts.keys.toList().indexOf(key) + 1}"),
                        title: Text("Product ID: $key"),
                        subtitle:
                            Text("Quantity: ${order.orderedProducts[key]![0]}"),
                        trailing: Text(
                            "Price: ${LuminUtll.formatCurrency(order.orderedProducts[key]![1])}"),
                      )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sp.getWidth(25, width),
                    bottom: sp.getHeight(10, height, width)),
                child: Text(
                  "Total Cost: ${LuminUtll.formatCurrency(order.totalCost)}",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: sp.getWidth(25, width),
                    bottom: sp.getHeight(10, height, width)),
                child: Text(
                  "Notes: ${order.notes}",
                ),
              ),
            ],
          )
    ];
  }

  Future<void> _handleSave(provider, String businessId) async {
    switch (widget.recordType) {
      case RecordType.product:
        bool isValid = validateProduct();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final inventoryProvider = provider as InventoryProvider;
          final p = widget.record as ProductModel;
          print(CurrencyInputFormatter().getAmount(costController.text));
          ProductModel updatedProduct = ProductModel(
            id: p.id,
            name: nameController.text,
            unitCost: CurrencyInputFormatter().getAmount(costController.text),
            quantity: int.tryParse(amountController.text) ?? 0,
            category: newCategory ?? selectedProductCategory!.name,
            unitPrice: CurrencyInputFormatter().getAmount(priceController.text),
          );

          await inventoryProvider.updateProduct(
            updatedProduct,
            businessId,
          );
          setState(() {
            isUpdating = false;
          });
          Navigator.pop(context);
        }

        break;
      case RecordType.customer:
        bool isValid = validateCustomer();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final customerProvider = provider as CustomerProvider;
          final c = widget.record as CustomerModel;
          await customerProvider.updateCustomer(
            CustomerModel(
                id: c.id,
                name: customerController.text,
                address: addressController.text,
                email: emailController.text,
                phoneNumber: phoneNumberController.text,
                orders: []),
            businessId,
          );

          setState(() {
            isUpdating = false;
          });
          Navigator.pop(context);
        }

        break;
      case RecordType.supplier:
        bool isValid = validateSupplier();
        if (isValid) {
          setState(() {
            isUpdating = true;
          });
          final supplierProvider = provider as SupplierProvider;
          final s = widget.record as SupplierModel;
          await supplierProvider.updateSupplier(
            SupplierModel(
                id: s.id,
                name: customerController.text,
                address: addressController.text,
                email: emailController.text,
                contactNumber: phoneNumberController.text,
                orders: s.orders,
                products: s.products),
            businessId,
          );
          setState(() {
            isUpdating = false;
          });
          Navigator.pop(context);
        }
        break;
      default:
        break;
    }
  }
}
