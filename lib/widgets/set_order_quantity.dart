import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:lumin_business/models/product.dart';
import 'package:provider/provider.dart';

class SetOrderQuantity extends StatefulWidget {
  final Product product;
  final ProductController productController;
  const SetOrderQuantity(
      {Key? key, required this.product, required this.productController})
      : super(key: key);

  @override
  State<SetOrderQuantity> createState() => _SetOrderQuantityState();
}

class _SetOrderQuantityState extends State<SetOrderQuantity> {
  final TextEditingController quantityController = TextEditingController();
  final SizeAndSpacing sp = SizeAndSpacing();
  String? quantityError;

  String shortenString(String input) {
    if (input.length <= 20) {
      return input;
    } else {
      return input.substring(0, 17) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      // backgroundColor: Colors.white,
      title: SizedBox(
        width: sp.getWidth(400, width),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              shortenString(widget.product.name),
              style: TextStyle(fontSize: sp.getFontSize(20, width)),
            ),
            Text(
              "Quantity: ${widget.product.quantity}",
              style: TextStyle(
                  color: Colors.red, fontSize: sp.getFontSize(14, width)),
            ),
          ],
        ),
      ),
      content: TextField(
        onChanged: (value) {
          if (quantityError != null) {
            setState(() {
              quantityError = null;
            });
          }
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        controller: quantityController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          errorText: quantityError,
          border: OutlineInputBorder(),
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          errorStyle: TextStyle(
            color: Colors.red,
          ),
          hintText: "Enter quantity to add to cart",
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")),
        TextButton(
            onPressed: () {
              if (quantityController.text.isEmpty) {
                setState(() {
                  quantityError = "Quantity cannot be empty";
                });
              } else if (!widget.productController.verifyQuantity(
                  widget.product, int.parse(quantityController.text))) {
                setState(() {
                  quantityError = "Order quantity cannot exceed stock";
                });
              } else if (quantityController.text == "0") {
                setState(() {
                  quantityError = "Order cannot be 0";
                });
              } else {
                widget.productController.addToOrder(
                    widget.product, int.parse(quantityController.text));
                print(widget.productController.openOrder);
                Navigator.pop(context);
              }
            },
            child: Text("Add to Cart")),
      ],
    );
  }
}
