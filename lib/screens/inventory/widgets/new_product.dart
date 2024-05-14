import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';

class NewProduct extends StatefulWidget {
  final ProductController productController;
  const NewProduct({Key? key, required this.productController})
      : super(key: key);

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool hasChanges = false;
  bool isUpdating = false;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AlertDialog(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Text(
            "Product Details",
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(width: sp.getWidth(20, width)),
          IconButton(onPressed: () {}, icon: Icon(Icons.copy))
        ],
      ),
      content: SizedBox(
        width: sp.getWidth(600, width),
        child: isUpdating
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (value) {
                      if (!hasChanges) {
                        setState(() {
                          hasChanges = true;
                        });
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: categoryController,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      if (!hasChanges) {
                        setState(() {
                          hasChanges = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Category",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: quantityController,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      if (!hasChanges) {
                        setState(() {
                          hasChanges = true;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Quantity",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    controller: unitPriceController,
                    onChanged: (value) {
                      if (!hasChanges) {
                        setState(() {
                          hasChanges = true;
                        });
                      }
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Unit Price",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
      ),
      actions: isUpdating
          ? []
          : [
              LuminTextIconButton(
                text:  "Add Product",
                icon: Icons.add,
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
            ],
    );
  }
}
