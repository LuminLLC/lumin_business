import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart'; 
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart'; 

import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final SizeAndSpacing  sp = SizeAndSpacing();
  @override
  void initState() {
    super.initState();
    // Provider.of<InventoryProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<InventoryProvider>(
        builder: (context, InventoryProvider, _) {
      return Container(
        margin: sp.isDesktop(screenWidth) ? EdgeInsets.all(10) : null,
        padding:sp.isDesktop(screenWidth) ? EdgeInsets.all(10) : null,
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: sp.isDesktop(screenWidth)
              ? BorderRadius.circular(30)
              : null,
        ),
        child: Column(
          children: [
            HeaderWidget(),
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
