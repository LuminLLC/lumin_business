import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class StatCardWidget extends StatelessWidget {
  final String statName;
  final IconData icon;
  String value;

  final SizeAndSpacing sp = SizeAndSpacing();

  StatCardWidget(
      {Key? key,
      required this.statName,
      required this.value,
      required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: (screenWidth - (screenWidth * 0.15)) / 4.5,
      decoration: BoxDecoration(
          color: AppColor.yellow, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(statName,
                  style: TextStyle(fontSize: sp.getFontSize(18, screenWidth))),
              SizedBox(
                height: sp.getHeight(10, screenHeight, screenWidth),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.black,
                  height: 1.5,
                ),
              ),
            ],
          ),
          if (MediaQuery.of(context).size.width >= 620) ...{
            Spacer(),
            Icon(
              icon,
              size: sp.getWidth(50, screenWidth),
              color: Colors.yellow,
            )
          }
        ],
      ),
    );
  }
}
