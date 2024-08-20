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
  final Product product;
  final AppState appState;
  final InventoryProvider inventoryProvider;
  const NewProduct(
      {Key? key,
      required this.product,
      required this.appState,
      required this.inventoryProvider})
      : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
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
    return Consumer2<InventoryProvider, AppState>(
        builder: (context, inventoryProvider, appState, _) {
      return AlertDialog(
        title: Row(
          children: [
            widget.product.image == null
                ? Container(
                    height: sp.getWidth(100, width),
                    width: sp.getWidth(100, width),
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                  )
                : Image.network(
                    widget.product.image!,
                    height: sp.getWidth(100, width),
                    width: sp.getWidth(100, width),
                  ),
            SizedBox(
              width: sp.getWidth(20, width),
            ),
            Text(
              "Add New Product",
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
                        onChanged: (value) {
                          if (!hasChanges) {
                            setState(() {
                              hasChanges = true;
                            });
                          }
                        },
                        style: TextStyle(fontSize: sp.getFontSize(16, width)),
                        decoration: InputDecoration(
                            labelText: "Product Name",
                            border: OutlineInputBorder(),
                            hintText: widget.product.name),
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
                        style: TextStyle(fontSize: sp.getFontSize(16, width)),
                        onChanged: (value) {
                          if (!hasChanges) {
                            setState(() {
                              hasChanges = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                            // enabled: widget.appState.user!.access == "admin",
                            labelText: "Quantity",
                            border: OutlineInputBorder(),
                            hintText: widget.product.quantity.toString()),
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
        actions:
            false //isUpdating || !(widget.appState.user!.access == "admin")
                ? []
                : [
                    LuminTextIconButton(
                      text: hasChanges ? "Save & Exit" : "Close",
                      icon: hasChanges ? Icons.save : Icons.close,
                      onPressed: () async {
                        Product p = Product(
                            id: widget.product.id,
                            name: nameController.text,
                            quantity: int.parse(quantityController.text),
                            category: inventoryProvider.selectedCategory!,
                            unitPrice: double.parse(priceController.text));
                        String productCode =
                            inventoryProvider.generateProductCode(
                                inventoryProvider.getCategoryCode(p), p);
                        if (hasChanges) {
                          setState(() {
                            isUpdating = true;
                          });
                          await widget.inventoryProvider.addProduct(
                            p,
                            appState.businessInfo!.businessId,
                            productCode,
                          );
                          setState(() {
                            isUpdating = false;
                          });
                          Navigator.pop(context);
                        } else {
                          // no changes
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
      );
    });
  }
}
