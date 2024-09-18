import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/order_management/order_controller.dart';
import 'package:provider/provider.dart';

class OrderPane extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
  OrderPane({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Consumer2<OrderProvider, AppState>(
        builder: (context, orderProvider, appState, _) {
      if (appState.businessInfo != null) {
        orderProvider.fetchOrders(appState.businessInfo!.businessId);
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Orders",
                style: GoogleFonts.dmSans(fontSize: sp.getFontSize(15, width)),
              ),
              Spacer(),
              Icon(
                Icons.filter_alt,
                size: sp.getWidth(15, width),
              )
            ],
          ),
          Divider(),
          orderProvider.orders == null
              ? CircularProgressIndicator()
              : orderProvider.orders!.isEmpty
                  ? Text(
                      "No Orders",
                      style: GoogleFonts.dmSans(
                          fontSize: sp.getFontSize(15, width)),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: orderProvider.orders!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text("${index + 1}"),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Order Details"),
                                      content: SizedBox(
                                        width: sp.getWidth(600, width),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(orderProvider
                                                  .orders![index].orderId),
                                              Text(orderProvider
                                                      .orders![index].status ??
                                                  "Unkown"),
                                              for (var item in orderProvider
                                                  .orders![index].orderItems)
                                                ListTile(
                                                  title: Text(
                                                      "${orderProvider.productLookup(item.productID, context).name}"),
                                                  subtitle: Text(
                                                      "${item.quantity} x ${LuminUtll.formatCurrency(item.price)}"),
                                                  trailing: Text(
                                                      "${LuminUtll.formatCurrency(item.itemTotal)}"),
                                                ),
                                              Divider(),
                                              ListTile(
                                                title: Text("Total"),
                                                trailing: Text(
                                                    "${LuminUtll.formatCurrency(orderProvider.orders![index].orderTotal)}"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            title: Text(
                              "${LuminUtll.formatCurrency(orderProvider.orders![index].orderTotal)}",
                              style: GoogleFonts.dmSans(
                                  fontSize: sp.getFontSize(15, width)),
                            ),
                            // subtitle: Text("Order details"),
                            trailing: Icon(
                              Icons.open_in_new,
                              size: sp.getWidth(15, width),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      );
    });
  }
}
