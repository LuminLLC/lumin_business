import 'package:flutter/material.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:lumin_business/models/product.dart';

class OpenOrder extends StatefulWidget {
  final ProductController productController;
  final AppState appState;
  const OpenOrder(
      {Key? key, required this.productController, required this.appState})
      : super(key: key);

  @override
  State<OpenOrder> createState() => _OpenOrderState();
}

class _OpenOrderState extends State<OpenOrder> {
  bool isCompletedOrderClicked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Open Order"),
      content: SingleChildScrollView(
        child: isCompletedOrderClicked
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  for (Product p
                      in widget.productController.fetchOpenOrder().keys)
                    ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                          "Quantity: ${widget.productController.fetchOpenOrder()[p]}"),
                      trailing: Text(
                          "GHS${p.unitPrice * widget.productController.fetchOpenOrder()[p]!}"),
                    ),
                  VerticalDivider(),
                  ListTile(
                    title: Text("Total"),
                    trailing: Text(
                        "GHS${widget.productController.fetchOpenOrder().keys.map((e) => e.unitPrice * widget.productController.fetchOpenOrder()[e]!).reduce((value, element) => value + element)}"),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.productController
                .clearOpenOrder(widget.appState.businessInfo!.businessId);
            Navigator.pop(context);
          },
          child: Text(
            "Cancel Order",
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: isCompletedOrderClicked
              ? null
              : () {
                  setState(() {
                    isCompletedOrderClicked = true;
                  });
                  widget.productController
                      .completeOrder(widget.appState.businessInfo!.businessId)
                      .whenComplete(() {
                    Navigator.pop(context);
                  });
                },
          child: Text(
            "Complete Order",
            style: TextStyle(
              color: isCompletedOrderClicked ? Colors.grey : null,
            ),
          ),
        ),
      ],
    );
  }
}
