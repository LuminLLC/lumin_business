import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';

class Chart extends StatelessWidget {
  final Map<String, double> dataMap;

  final SizeAndSpacing sp = SizeAndSpacing();
  Chart({required this.dataMap});

  double getMaxValue(List<double> numbers) {
    if (numbers.isEmpty) {
      throw ArgumentError("The list is empty.");
    }

    return numbers.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: getMaxValue(dataMap.values.toList()) + 5,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(dataMap.keys.elementAt(value.toInt()), style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  // List<BarChartGroupData> get barGroups => [
  //       BarChartGroupData(
  //         x: 0,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 8,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 1,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 10,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 2,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 14,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 3,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 15,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 4,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 13,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 5,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 10,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //       BarChartGroupData(
  //         x: 6,
  //         barRods: [
  //           BarChartRodData(
  //             toY: 16,
  //             gradient: _barsGradient,
  //           )
  //         ],
  //         showingTooltipIndicators: [0],
  //       ),
  //     ];

  List<BarChartGroupData> get barGroups {
    List<BarChartGroupData> barGroups = [];
    dataMap.forEach((key, value) {
      barGroups.add(BarChartGroupData(
        x: dataMap.keys.toList().indexOf(key),
        barRods: [
          BarChartRodData(
            toY: value,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    });
    return barGroups;
  }
}

class BarChartSample3 extends StatefulWidget {
  final Map<String, double> dataMap;
  BarChartSample3({required this.dataMap});
  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: Chart(
        dataMap: widget.dataMap,
      ),
    );
  }
}
