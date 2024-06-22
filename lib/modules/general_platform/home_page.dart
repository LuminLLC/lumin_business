import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:provider/provider.dart';
import '../../controllers/menu_controller.dart';
import '../inventory/inventory.dart';
import 'side_bar_menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SizeAndSpacing sp = SizeAndSpacing();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    print(sp.isDesktop(screenWidth));
    return Scaffold(
      bottomNavigationBar: AppResponsive.isDesktop(context) ? null : Menu(),
      key: Provider.of<PlatformMenuController>(context, listen: false)
          .scaffoldKey,
      backgroundColor: AppColor.bgSideMenu,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (AppResponsive.isDesktop(context))
              Container(width: screenWidth * 0.15, child: Menu()),

            /// Main Body Part
            Expanded(
                // width: screenWidth *0.8,
                child: Inventory()),
          ],
        ),
      ),
    );
  }
}
