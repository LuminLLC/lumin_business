import 'package:flutter/material.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/order_management/lumin_order.dart';
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
                  for (OrderItem item
                      in widget.orderProvider.fetchOpenOrder()!.orderItems)
                    SizedBox(
                      width: width * 0.3,
                      child: ListTile(
                        title: Text(widget.orderProvider
                            .productLookup(item.productID, context)
                            .name),
                        subtitle: Text("Quantity: ${item.quantity}"),
                        trailing: Text(
                            LuminUtll.formatCurrency(item.price * item.price)),
                      ),
                    ),
                  Divider(
                    color: Colors.white,
                  ),
                  ListTile(
                      title: Text("Total"),
                      trailing: Text(
                        LuminUtll.formatCurrency(
                            widget.orderProvider.openOrder!.orderTotal),
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
