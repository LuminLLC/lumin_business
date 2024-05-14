import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:provider/provider.dart';
import '../controllers/menu_controller.dart';
import 'inventory/inventory.dart';
import '../widgets/side_bar_menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SizeAndSpacing sp = SizeAndSpacing();
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    print(sp.isDesktop(screenWidth));
    return !sp.isDesktop(screenWidth)
        ? Scaffold(
            body: Container(
                height: screenHeight,
                width: screenWidth,
                color: AppColor.bgSideMenu,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo_white_nobg.png',
                      height: 400,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "Lumin Business is not supported on mobile and tab screens at the moment. Please reload this page on a desktop screen to continue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: sp.getFontSize(12, screenWidth),
                            height: 1.4),
                      ),
                    )
                  ],
                )),
          )
        : Scaffold(
            drawer: SideBar(),
            key: Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey,
            backgroundColor: AppColor.bgSideMenu,
            body: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Side Navigation Menu
                  /// Only show in desktop
                  if (AppResponsive.isDesktop(context))
                    Expanded(
                      child: SideBar(),
                    ),

                  /// Main Body Part
                  Expanded(
                    flex: 4,
                    child: Inventory(),
                  ),
                ],
              ),
            ),
          );
  }
}
