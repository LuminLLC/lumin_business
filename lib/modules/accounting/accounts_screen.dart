import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:lumin_business/modules/inventory/product_data_widget.dart';
import 'package:lumin_business/modules/inventory/stat_card.dart';
import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';

class AccountingScreen extends StatefulWidget {
  @override
  _AccountingScreenState createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
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
              Spacer(),
            Icon(
              FontAwesomeIcons.clock,
              color: Colors.black,
              size: 50,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Feature Coming Soon!',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
          ],
        ),
      );
    });
  }
}
