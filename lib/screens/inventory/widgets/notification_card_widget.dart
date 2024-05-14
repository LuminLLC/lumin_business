import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/product_controller.dart'; 
import 'package:provider/provider.dart';

class NotificationCardWidget extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: AppColor.yellow, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Consumer<ProductController>(
            builder: (context, productController, _) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hey there! 👋",
                    style: TextStyle(fontSize: sp.getFontSize(18, screenWidth))),
                SizedBox(
                  height: sp.getHeight(10, screenHeight, screenWidth),
                ),
                Text(
                  "Your total product count is ${productController.allProdcuts.length}",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                   height: sp.getHeight(10, screenHeight, screenWidth),
                ),
                Text(
                  "${productController.calculateOutofStock()} products are out of stock",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: sp.getHeight(10, screenHeight, screenWidth),
                ),
                Text(
                  "${productController.calculateOutofStock()} products are at critical level",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColor.black,
                    height: 1.5,
                  ),
                ),
                SizedBox(
                  height: sp.getHeight(10, screenHeight, screenWidth),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Read More",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColor.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width >= 620) ...{
            Spacer(),
            Icon(
              Icons.notifications,
              size: 100,
              color: Colors.yellow,
            )
          }
        ],
      ),
    );
  }
}
