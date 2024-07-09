import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/custom_dropdown.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:provider/provider.dart';

class NewProduct extends StatefulWidget {
  final AppState appState;
  final InventoryProvider inventoryProvider;

  const NewProduct(
      {Key? key, required this.appState, required this.inventoryProvider})
      : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String? nameError;
  bool categoryError = false;
  String? quantityError;
  String? unitPriceError;
  String? categoryErrorText;
  String categoryCode = "";

  final SizeAndSpacing sp = SizeAndSpacing();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  bool hasChanges = false;
  bool isUpdating = false;

  bool validateForm() {
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Product Name cannot be empty";
      });
      return false;
    } else if (quantityController.text.isEmpty) {
      setState(() {
        quantityError = "Quantity cannot be empty";
      });
      return false;
    } else if (unitPriceController.text.isEmpty) {
      setState(() {
        unitPriceError = "Unit Price cannot be empty";
      });
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Text(
        categoryError ? "Create new category" : "Enter Product Details",
        style: TextStyle(fontSize: sp.getFontSize(24, width)),
      ),
      content: SizedBox(
        width: sp.getWidth(600, width),
        child: isUpdating
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryError
                      //for adding  new category
                      ? [
                          TextField(
                            controller: nameController,
                            onChanged: (value) {
                              if (categoryErrorText != null) {
                                setState(() {
                                  categoryErrorText = null;
                                });
                              }
                            },
                            style:
                                TextStyle(fontSize: sp.getFontSize(16, width)),
                            decoration: InputDecoration(
                                errorText: nameError,
                                labelText: "Category Name",
                                border: OutlineInputBorder(),
                                hintText: "Enter Category Name"),
                          ),
                        ]
                      //for adding new product
                      : [
                          SizedBox(
                            height: sp.getHeight(35, width, height),
                          ),
                          TextField(
                            controller: nameController,
                            onChanged: (value) {
                              if (nameError != null) {
                                setState(() {
                                  nameError = null;
                                });
                              }
                            },
                            style:
                                TextStyle(fontSize: sp.getFontSize(16, width)),
                            decoration: InputDecoration(
                                errorText: nameError,
                                labelText: "Product Name",
                                border: OutlineInputBorder(),
                                hintText: "Enter Product Name"),
                          ),
                          SizedBox(
                            height: sp.getHeight(35, width, height),
                          ),
                          CustomDropdownWidget(),
                          SizedBox(
                            height: sp.getHeight(35, width, height),
                          ),
                          TextField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+')),
                              // Limit input to 4 digits, which allows values up to 1000
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style:
                                TextStyle(fontSize: sp.getFontSize(16, width)),
                            onChanged: (value) {
                              if (quantityError != null) {
                                setState(() {
                                  quantityError = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                labelText: "Quantity",
                                border: OutlineInputBorder(),
                                hintText: "Enter Quantity"),
                          ),
                          SizedBox(
                            height: sp.getHeight(35, width, height),
                          ),
                          TextField(
                            controller: unitPriceController,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true), // Allows decimal input
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d+\.?\d{0,2}')), // Restricts input to valid decimal numbers
                            ],
                            onChanged: (value) {
                              if (unitPriceError != null) {
                                setState(() {
                                  unitPriceError = null;
                                });
                              }
                            },
                            style:
                                TextStyle(fontSize: sp.getFontSize(16, width)),
                            decoration: InputDecoration(
                                prefix: Text("GHS "),
                                labelText: "Unit Price",
                                border: OutlineInputBorder(),
                                hintText: "Enter Unit Price"),
                          ),
                          SizedBox(
                            height: sp.getHeight(35, width, height),
                          ),
                        ],
                ),
              ),
      ),
      actions: isUpdating
          ? []
          : categoryError
              ? [
                  TextButton(
                      onPressed: () {},
                      child: Text("Create Category and Add Product")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          categoryError = false;
                        });
                      },
                      child: Text("Add Product to Existing Category"))
                ]
              : [
                  Consumer2<InventoryProvider, AppState>(
                    builder: (context, InventoryProvider, appState, _) =>
                        LuminTextIconButton(
                      text: "Add Product",
                      icon: Icons.add,
                      onPressed: () async {
                        if (validateForm()) {
                          setState(() {
                            isUpdating = true;
                          });
                          Product p = Product(
                            name: nameController.text,
                            id: {InventoryProvider.allProdcuts.length + 1}
                                .toString(),
                            category: InventoryProvider.selectedCategory!,
                            quantity: int.parse(quantityController.text),
                            unitPrice: double.parse(unitPriceController.text),
                          );
                          String productCode =
                              InventoryProvider.generateProductCode(
                                  categoryCode, p);

                          await InventoryProvider.addProduct(
                                  p,
                                  appState.businessInfo!.businessId,
                                  productCode)
                              .whenComplete(() {
                            setState(() {
                              isUpdating = false;
                            });
                            print("here");
                            Navigator.pop(context);
                          });
                        }
                        // if (InventoryProvider.selectedCategory == null) {
                        //   setState(() {
                        //     categoryError = true;
                        //   });
                        //   return;
                        // }
                        // print(nameController.text +
                        //     quantityController.text +
                        //     unitPriceController.text +
                        //     "${InventoryProvider.selectedCategory}");
                        // // if (validateForm()) {}
                      },
                    ),
                  ),
                ],
    );
  }
}
