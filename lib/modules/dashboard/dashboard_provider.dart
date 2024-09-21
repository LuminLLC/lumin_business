import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/modules/order_management/lumin_order.dart';
import 'package:lumin_business/modules/order_management/order_controller.dart';

class DashboardProvider with ChangeNotifier {
  Map<String, List<LuminOrder>> allOrders = {};
  List<FlSpot> spotData = [];

  LineChartBarData getLineChartBarData() {
    return LineChartBarData(
      spots: spotData,
      isCurved: true,
      barWidth: 4,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
    );
  }

  Future<void> fetchOrders(String businessID) async {
    await OrderProvider().fetchAllOrders(businessID).then((value) {
      allOrders = value;
      for (String s in allOrders.keys) {
        for (LuminOrder order in allOrders[s]!) {
          spotData.add(FlSpot(allOrders[s]!.indexOf(order).toDouble(), 10));
        }
      }
    });
    print(allOrders);
  }
}
