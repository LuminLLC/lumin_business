import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';

class SelectedProduct extends StatefulWidget {
  final ProductModel product;
  final AppState appState;
  final InventoryProvider inventoryProvider;
  const SelectedProduct(
      {Key? key,
      required this.product,
      required this.appState,
      required this.inventoryProvider})
      : super(key: key);

  @override
  State<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends State<SelectedProduct> {
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
    nameController = TextEditingController()..text = widget.product.name;
    categoryController = TextEditingController()
      ..text = widget.product.category;
    quantityController = TextEditingController()
      ..text = widget.product.quantity.toString();
    priceController = TextEditingController()
      ..text = widget.product.unitPrice.toString();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? image;
    if (widget.product.image != null &&
        widget.product.image!.runtimeType != String) {
      image = Uint8List.fromList(widget.product.image.cast<int>());
    }
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
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
              : Image.memory(
                  image ?? Uint8List.fromList([]),
                  height: sp.getWidth(100, width),
                  width: sp.getWidth(100, width),
                ),
          SizedBox(
            width: sp.getWidth(20, width),
          ),
          Text(
            "Product Details",
            style: TextStyle(fontSize: sp.getFontSize(24, width)),
          ),
          SizedBox(width: sp.getWidth(20, width)),
          widget.appState.user!.access == "admin"
              ? IconButton(onPressed: () {}, icon: Icon(Icons.copy))
              : Text(
                  "(${widget.product.id})",
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
              primary: false,
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
                          enabled: widget.appState.user!.access == "admin",
                          labelText: "Product Name",
                          border: OutlineInputBorder(),
                          hintText: widget.product.name),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: categoryController,
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      onChanged: (value) {
                        if (!hasChanges) {
                          setState(() {
                            hasChanges = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          labelText: "Category",
                          enabled: widget.appState.user!.access == "admin",
                          border: OutlineInputBorder(),
                          hintText: widget.product.category.toString()),
                    ),
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
                      onChanged: (value) {
                        if (!hasChanges) {
                          setState(() {
                            hasChanges = true;
                          });
                        }
                      },
                      // enabled: widget.appState.user!.access == "admin",
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      decoration: InputDecoration(
                          labelText: "Unit Price",
                          border: OutlineInputBorder(),
                          hintText: widget.product.unitPrice.toString()),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                  ],
                ),
              ),
      ),
      actions: false //isUpdating || !(widget.appState.user!.access == "admin")
          ? []
          : [
              LuminTextIconButton(
                text: hasChanges ? "Save & Exit" : "Exit",
                icon: hasChanges ? Icons.save : Icons.close,
                onPressed: () async {
                  if (hasChanges) {
                    setState(() {
                      isUpdating = true;
                    });
                    await widget.inventoryProvider.updateProduct(
                        ProductModel(
                            id: widget.product.id,
                            name: nameController.text,
                            quantity: int.parse(quantityController.text),
                            category: categoryController.text,
                            unitPrice: double.parse(priceController.text)),
                        widget.appState.businessInfo!.businessId);
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
              LuminTextIconButton(
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  text: "Delete Product",
                  icon: Icons.delete,
                  onPressed: () async {
                    setState(() {
                      isUpdating = true;
                    });
                    await widget.inventoryProvider.deleteProduct(widget.product,
                        widget.appState.businessInfo!.businessId);
                    setState(() {
                      isUpdating = false;
                    });
                    Navigator.pop(context);
                  }),
            ],
    );
  }
}
