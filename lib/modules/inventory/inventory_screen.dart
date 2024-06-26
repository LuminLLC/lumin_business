import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';
import 'stat_card.dart';
import 'product_data_widget.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StatCardWidget(
                  statName: "Inventory Count",
                  value: "${productController.allProdcuts.length}",
                  icon: Icons.inventory,
                ),
                Spacer(),
                StatCardWidget(
                  statName: "Today's Sales",
                  value: "GHS${productController.calculateOutofStock()}",
                  icon: Icons.attach_money,
                ),
                Spacer(),
                StatCardWidget(
                  statName: "Critical Level",
                  value: "GHS${productController.calculateOutofStock()}",
                  icon: Icons.warning,
                ),
                Spacer(),
                StatCardWidget(
                  statName: "Out of Stock",
                  value: "GHS${productController.calculateOutofStock()}",
                  icon: Icons.check_box_outline_blank_sharp,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ProductDataWidget(),
          ],
        ),
      );
    });
  }
}
