import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/general_platform/stat_card.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/temp.dart';

import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';

class DashboadScreen extends StatefulWidget {
  @override
  _DashboadScreenState createState() => _DashboadScreenState();
}

class _DashboadScreenState extends State<DashboadScreen> {
  final SizeAndSpacing sp = SizeAndSpacing();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Consumer2<AccountingProvider, InventoryProvider>(
        builder: (context, accountingProvider, inventoryProvider, _) {
      return Container(
        margin: EdgeInsets.all(sp.getWidth(10, screenWidth)),
        padding: EdgeInsets.all(sp.getWidth(10, screenWidth)),
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius:
              sp.isDesktop(screenWidth) ? BorderRadius.circular(30) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            HeaderWidget(
              actions: [],
            ),
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatCardWidget(
                      statName: "Net Income",
                      value: "100",
                      icon: Icons.show_chart),
                  StatCardWidget(
                      statName: "Product Sales",
                      value: "100",
                      icon: Icons.point_of_sale),
                  StatCardWidget(
                      statName: "Total Cost of Product",
                      value:
                          inventoryProvider.calculateCriticalLevel().toString(),
                      icon: Icons.warning),
                  StatCardWidget(
                      statName: "Stock Levels",
                      value: inventoryProvider.calculateOutofStock().toString(),
                      icon: Icons.dangerous),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(width: screenWidth / 2.5, child: ChartExample()),
                    Container(
                      color: Colors.blue,
                      width: screenWidth / 2.5,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
