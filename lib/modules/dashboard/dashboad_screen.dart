import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/custom_chart.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/dashboard/dashboard_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/stat_card.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/row_to_column.dart';
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
    return Consumer4<AppState, DashboardProvider, AccountingProvider,
            InventoryProvider>(
        builder: (context, appState, dashboardProvider, accountingProvider,
            inventoryProvider, _) {
      dashboardProvider.fetchOrders(appState.businessInfo!.businessId);
      return Container(
        margin: EdgeInsets.all(
            sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth)),
        padding: EdgeInsets.only(
          top: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 5, screenWidth),
          bottom: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
          left: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
          right: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
        ),
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius:
              sp.isDesktop(screenWidth) ? BorderRadius.circular(30) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (sp.isDesktop(screenWidth))
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
                      value: LuminUtll.formatCurrency(
                          accountingProvider.netIncome),
                      icon: Icons.show_chart),
                  StatCardWidget(
                      statName: "Product Sales",
                      value: "100",
                      icon: Icons.point_of_sale),
                  StatCardWidget(
                      statName: "Items in critical level",
                      value:
                          inventoryProvider.calculateCriticalLevel().toString(),
                      icon: Icons.warning),
                  StatCardWidget(
                      statName: "Items out of stock",
                      value: inventoryProvider.calculateOutofStock().toString(),
                      icon: Icons.dangerous),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: RowToColumn(
                  isDesktop: sp.isDesktop(screenWidth),
                  children: [
                    Consumer<AccountingProvider>(
                      builder: (context, accountingProvider, _) => Container(
                        height: screenHeight * 0.8,
                        width: sp.isDesktop(screenWidth)
                            ? screenWidth / 2.5
                            : screenWidth,
                        child: Chart(
                          dataMap: accountingProvider.lastSevenDaysTransactions,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.bgColor,
                        borderRadius: BorderRadius.circular(30),
                        shape: BoxShape.rectangle,
                        border: Border.all(
                          color: AppColor.blue,
                          width: 1,
                        ),
                      ),
                      width: screenWidth / 2.5,
                      child: Column(
                        children: [
                          Text("Best selling product"),
                          Text("Best selling product"),
                          Text("Most frequent customer"),
                          Text("Largest spend customer"),
                        ],
                      ),
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
