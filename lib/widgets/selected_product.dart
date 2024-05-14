import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';

class SelectedProduct extends StatefulWidget {
  final Product product;
  final AppState appState;
  final ProductController productController;
  const SelectedProduct(
      {Key? key,
      required this.product,
      required this.appState,
      required this.productController})
      : super(key: key);

  @override
  State<SelectedProduct> createState() => _SelectedProductState();
}

class _SelectedProductState extends State<SelectedProduct> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool hasChanges = false;
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Row(
        children: [
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
                child: CircularProgressIndicator(),
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
                      controller: TextEditingController()
                        ..text = widget.product.name,
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
                      controller: TextEditingController()
                        ..text = widget.product.category.toString(),
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
                      controller: TextEditingController()
                        ..text = widget.product.quantity.toString(),
                      style: TextStyle(fontSize: sp.getFontSize(16, width)),
                      onChanged: (value) {
                        if (!hasChanges) {
                          setState(() {
                            hasChanges = true;
                          });
                        }
                      },
                      decoration: InputDecoration(
                          enabled: widget.appState.user!.access == "admin",
                          labelText: "Quantity",
                          border: OutlineInputBorder(),
                          hintText: widget.product.quantity.toString()),
                    ),
                    SizedBox(
                      height: sp.getHeight(35, width, height),
                    ),
                    TextField(
                      controller: TextEditingController()
                        ..text = widget.product.unitPrice.toString(),
                      onChanged: (value) {
                        if (!hasChanges) {
                          setState(() {
                            hasChanges = true;
                          });
                        }
                      },
                      enabled: widget.appState.user!.access == "admin",
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
      actions: isUpdating || !(widget.appState.user!.access == "admin")
          ? []
          : [
              LuminTextIconButton(
                text: hasChanges ? "Save & Exit" : "Exit",
                icon: hasChanges ? Icons.save : Icons.close,
                onPressed: () async {
                  // if (hasChanges) {
                  //   setState(() {
                  //     isUpdating = true;
                  //   });
                  //   await widget.productController
                  //       .updateProduct(widget.product);
                  //   setState(() {
                  //     isUpdating = false;
                  //   });
                  //   Navigator.pop(context);
                  // } else {
                  //   // no changes
                  //   Navigator.pop(context);
                  // }
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
                    await widget.productController
                        .deleteProduct(widget.product, widget.appState.businessInfo!.businessId);
                    setState(() {
                      isUpdating = false;
                    });
                    Navigator.pop(context);
                  }),
            ],
    );
  }
}
