import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
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
    return Consumer<InventoryProvider>(
        builder: (context, InventoryProvider, _) {
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
                      statName: "statName", value: "100", icon: Icons.abc),
                  StatCardWidget(
                      statName: "statName", value: "100", icon: Icons.abc),
                  StatCardWidget(
                      statName: "statName", value: "100", icon: Icons.abc),
                  StatCardWidget(
                      statName: "statName", value: "100", icon: Icons.abc),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                        // height: screenHeight / 2.2,
                        width: screenWidth / 2.5,
                        child: ChartExample()),
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
