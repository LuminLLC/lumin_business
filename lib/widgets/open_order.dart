import 'package:flutter/material.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/order_management/order_controller.dart';

class OpenOrder extends StatefulWidget {
  final OrderProvider orderProvider;
  final AppState appState;
  const OpenOrder(
      {Key? key, required this.orderProvider, required this.appState})
      : super(key: key);

  @override
  State<OpenOrder> createState() => _OpenOrderState();
}

class _OpenOrderState extends State<OpenOrder> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool isCompletedOrderClicked = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      title: Text("Open Order"),
      content: SingleChildScrollView(
        primary: false,
        child: isCompletedOrderClicked
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  for (ProductModel p
                      in widget.orderProvider.fetchOpenOrder().keys)
                    SizedBox(
                      width: width * 0.3,
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text(
                            "Quantity: ${widget.orderProvider.fetchOpenOrder()[p]}"),
                        trailing: Text(LuminUtll.formatCurrency(p.unitPrice *
                            widget.orderProvider.fetchOpenOrder()[p]!)),
                      ),
                    ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                      title: Text("Total"),
                      trailing: Text(
                        LuminUtll.formatCurrency(widget.orderProvider
                            .fetchOpenOrder()
                            .keys
                            .map((e) =>
                                e.unitPrice *
                                widget.orderProvider.fetchOpenOrder()[e]!)
                            .reduce((value, element) => value + element)),
                      )),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.orderProvider
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
                  widget.orderProvider
                      .completeOrder(
                          widget.appState.businessInfo!.businessId, context)
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
