import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:provider/provider.dart';

import 'calender_widget.dart';
import 'header_widget.dart';
import 'stat_card.dart';
import 'categories_card_widget.dart';
import 'product_data_widget.dart';

class Inventory extends StatefulWidget {
  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    super.initState();
    // Provider.of<ProductController>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
        builder: (context, productController, _) {
      return Container(
        margin: AppResponsive.isDesktop(context) ? EdgeInsets.all(10) : null,
        padding: AppResponsive.isDesktop(context) ? EdgeInsets.all(10) : null,
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: AppResponsive.isDesktop(context)
              ? BorderRadius.circular(30)
              : null,
        ),
        child: Column(
          children: [
            HeaderWidget(), //module name
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              StatCardWidget(
                                statName: "Inventory Count",
                                value:
                                    "${productController.allProdcuts.length}",
                                icon: Icons.inventory,
                              ),
                              Spacer(),
                              StatCardWidget(
                                statName: "Today's Sales",
                                value:
                                    "GHS${productController.calculateOutofStock()}",
                                icon: Icons.attach_money,
                              ),
                              Spacer(),
                              StatCardWidget(
                                statName: "Critical Level",
                                value:
                                    "GHS${productController.calculateOutofStock()}",
                                icon: Icons.warning,
                              ),
                              Spacer(),
                              StatCardWidget(
                                statName: "Out of Stock",
                                value:
                                    "GHS${productController.calculateOutofStock()}",
                                icon: Icons.check_box_outline_blank_sharp,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (AppResponsive.isMobile(context)) ...{
                            OrderWidget(),
                            SizedBox(
                              height: 20,
                            ),
                          },
                          ProductDataWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
