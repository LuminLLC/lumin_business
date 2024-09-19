import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text("New Order"),
            trailing: IconButton(
              icon: Icon(Icons.person_add),
              onPressed: () {},
            ),
          ),
          DropdownButtonFormField<dynamic>(
            hint: Text(
              "Select a POS Location",
              style: TextStyle(
                color:
                    Colors.grey[300], // Adjust this color to match your style
              ),
            ),
            value: null,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              // errorText: transactionTypeError,
              // hintText: "Select a transaction type",
              // labelText: "Transaction Type",
              hintStyle: TextStyle(
                color:
                    Colors.grey[300], // Adjust this color to match your style
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5), // Rounded corners
                borderSide: BorderSide(
                  color: Colors.grey[50]!, // Border color
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
                color:
                    Colors.grey[700], // Adjust this color to match your style
              ),
            ),
            style: TextStyle(
              color: Colors.white, // Text color inside the dropdown
              fontSize: 16.0, // Text size inside the dropdown
            ),
            onChanged: (value) {},
            items: widget.appState.businessInfo!.posLocations
                .map<DropdownMenuItem<dynamic>>((dynamic value) {
              return DropdownMenuItem<dynamic>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        primary: false,
        child: isCompletedOrderClicked
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  ListTile(
                    minVerticalPadding: 0,
                    leading: Text("Items",
                        style: GoogleFonts.dmSans(
                            fontSize: sp.getFontSize(20, width))),
                  ),
                  Divider(),
                  for (OrderItem item
                      in widget.orderProvider.fetchOpenOrder()!.orderItems)
                    SizedBox(
                      width: width * 0.3,
                      child: ListTile(
                        leading: Text(
                            "${widget.orderProvider.fetchOpenOrder()!.orderItems.indexOf(item) + 1}"),
                        title: Text(widget.orderProvider
                            .productLookup(item.productID, context)
                            .name),
                        subtitle: Text("Quantity: ${item.quantity}"),
                        trailing: Text(
                            LuminUtll.formatCurrency(item.price * item.quantity)),
                      ),
                    ),
                  Divider(),
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
