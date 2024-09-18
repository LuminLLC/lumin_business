import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/menu_controller.dart';
import 'package:lumin_business/modules/order_management/order_pane.dart';

import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final AppTextTheme textTheme = AppTextTheme();
  final SizeAndSpacing sp = SizeAndSpacing();
  bool isSigningOut = false;
  List<dynamic> menuItems = [];

  @override
  void initState() {
    super.initState();
  }

  void _getMenuItems(
      BuildContext context, AppState appState, double screenWidth) {
    menuItems = [
      menuItemDesktop(
        title: "Dashboard",
        context: context,
        index: 0,
        icon: Icon(Icons.home),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(0);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      ),
      menuItemDesktop(
        title: "Accounting",
        context: context,
        index: 1,
        icon: Icon(FontAwesomeIcons.calculator),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(1);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      ),
      menuItemDesktop(
        title: "Inventory",
        context: context,
        icon: Icon(FontAwesomeIcons.store),
        hasTrailing: true,
        index: 2,
        appState: appState,
        press: () {
          appState.setIndex(2);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      ),
      menuItemDesktop(
        title: "Customers",
        context: context,
        icon: Icon(FontAwesomeIcons.person),
        hasTrailing: true,
        index: 3,
        appState: appState,
        press: () {
          appState.setIndex(3);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      ),
      menuItemDesktop(
        title: "Suppliers",
        context: context,
        index: 4,
        icon: Icon(FontAwesomeIcons.peopleCarryBox),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(4);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      ),
      menuItemDesktop(
        title: "Settings",
        context: context,
        index: 5,
        appState: appState,
        icon: Icon(Icons.settings),
        hasTrailing: true,
        press: () {
          appState.setIndex(5);
          if (!(sp.isDesktop(screenWidth))) {
            Provider.of<PlatformMenuController>(context, listen: false)
                .scaffoldKey
                .currentState!
                .closeDrawer();
          }
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: false).fetchUser(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<AppState>(builder: (context, appState, _) {
      _getMenuItems(context, appState, screenWidth);
      return Container(
        color: AppColor.bgSideMenu,
        width: !sp.isDesktop(screenWidth) ? screenWidth / 1.5 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appState.businessInfo == null
                ? Image.asset(
                    "assets/logo_white_nobg.png",
                    height: sp.getHeight(200, screenHeight, screenWidth),
                    width: double.infinity,
                  )
                : Container(
                    margin: sp.isDesktop(screenWidth)
                        ? EdgeInsets.all(10)
                        : EdgeInsets.only(
                            top: sp.getHeight(30, screenHeight, screenWidth),
                            left: sp.getWidth(20, screenWidth),
                            right: sp.getHeight(20, screenHeight, screenWidth)),
                    padding:
                        sp.isDesktop(screenWidth) ? EdgeInsets.all(10) : null,
                    decoration: BoxDecoration(
                      color: AppColor.blue.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: sp.getWidth(5, screenWidth)),
                      // tileColor: Colors.white,
                      title: Text(
                          appState.user == null || appState.user!.name == ""
                              ? ""
                              : "Hello, ${appState.user!.name.split(" ").toList()[0]}",
                          style: textTheme.textTheme(screenWidth).bodyLarge!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Divider(
                            color: AppColor.bgSideMenu,
                            thickness: .25,
                          ),
                          Row(children: [
                            Icon(
                              appState.user!.access == "admin"
                                  ? FontAwesomeIcons.person
                                  : FontAwesomeIcons.store,
                              size: sp.getWidth(15, screenWidth),
                            ),
                            SizedBox(width: sp.getWidth(10, screenWidth)),
                            Text(
                                appState.businessInfo == null ||
                                        appState.businessInfo!.businessName ==
                                            ""
                                    ? "Lumin Business"
                                    : appState.businessInfo!.businessName,
                                style: textTheme
                                    .textTheme(screenWidth)
                                    .labelSmall!),
                          ]),
                        ],
                      ),
                      trailing: Icon(
                        Icons.sync,
                        color: Colors.green,
                      ), //Icons.sync_disabled
                    )),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            if (appState.user != null && appState.user!.access == "admin")
              for (Widget w in menuItems) w,

            if (appState.user != null && appState.user!.access != "admin")
              Container(
                  margin: EdgeInsets.only(
                    left: sp.getWidth(10, screenWidth),
                  ),    
                  width: !sp.isDesktop(screenWidth) ? screenWidth / 1.5 : null,
                  height: screenHeight * 0.6,
                  child: OrderPane()),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: menuItemDesktop(
                title: "Logout",
                context: context,
                appState: appState,
                hasTrailing: false,
                icon: Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Colors.red,
                ),
                press: () {
                  if (!isSigningOut) {
                    setState(() {
                      isSigningOut = true;
                    });
                    appState.signOut().whenComplete(() {
                      setState(() {
                        isSigningOut = false;
                      });
                      appState.masterClearData(context);
                      Navigator.pushReplacementNamed(context, "/sign-in");
                    });
                  }
                },
              ),
            ),
            // appState.user != null && appState.user!.access == "admin"
            //     ? menuItemDesktop(
            //         title: "Order History",
            //         context: context,
            //         appState: appState,
            //         icon: Icon(Icons.list),
            //         hasTrailing: false,
            //         press: () {},
            //       )
            //     : SizedBox(),
          ],
        ),
      );
    });
  }

  Widget menuItemDesktop(
      {required String title,
      required Icon icon,
      int? index,
      required VoidCallback press,
      required AppState appState,
      required BuildContext context,
      required bool hasTrailing}) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
          bottom: sp.getHeight(
            20,
            screenHeight,
            screenWidth,
          ),
          right: sp.isDesktop(screenWidth) ? 0 : sp.getWidth(10, screenWidth),
          left: sp.getWidth(10, screenWidth)),
      child: Container(
          decoration: BoxDecoration(
            color: appState.index == index
                ? AppColor.blue.withOpacity(0.5)
                : AppColor.bgSideMenu,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: press,
            horizontalTitleGap: sp.getWidth(20, screenWidth),
            leading: icon,
            title: Text(
              title,
              style: textTheme.textTheme(screenWidth).bodyMedium,
            ),
          )),
    );
  }
}
