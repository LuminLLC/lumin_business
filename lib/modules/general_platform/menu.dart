import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';

import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool isSigningOut = false;
  List<dynamic> menuItems = [];
  List<BottomNavigationBarItem> menuItemsTabAndMobile = [];

  @override
  void initState() {
    super.initState();
  }

  void _getMenuItems(BuildContext context, AppState appState) {
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
        },
      ),
      menuItemDesktop(
        title: "Accounting",
        context: context,
        index: 1,
        icon: Icon(FontAwesomeIcons.cashRegister),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(1);
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
        },
      ),
      menuItemDesktop(
        title: "Utilites",
        context: context,
        index: 5,
        appState: appState,
        icon: Icon(Icons.settings),
        hasTrailing: true,
        press: () {
          appState.setIndex(5);
        },
      )
    ];

    menuItemsTabAndMobile = [
      menuItemTabAndMobile(
        title: "Dashboard",
        context: context,
        icon: Icon(Icons.home),
        hasTrailing: true,
        appState: appState,
      ),
      menuItemTabAndMobile(
        title: "Accounting",
        context: context,
        icon: Icon(FontAwesomeIcons.cashRegister),
        hasTrailing: true,
        appState: appState,
      ),
      menuItemTabAndMobile(
        title: "Inventory",
        context: context,
        icon: Icon(FontAwesomeIcons.store),
        hasTrailing: true,
        appState: appState,
      ),
      menuItemTabAndMobile(
        title: "Customers",
        context: context,
        icon: Icon(FontAwesomeIcons.person),
        hasTrailing: true,
        appState: appState,
      ),
      menuItemTabAndMobile(
        title: "Suppliers",
        context: context,
        icon: Icon(FontAwesomeIcons.peopleCarryBox),
        hasTrailing: true,
        appState: appState,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: false).fetchUser(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<AppState>(builder: (context, appState, _) {
      _getMenuItems(context, appState);
      return !AppResponsive.isDesktop(context)
          ? BottomNavigationBar(
              items: menuItemsTabAndMobile,
              onTap: (index) => appState.setIndex(index),
              currentIndex: appState.index,
              backgroundColor: AppColor.bgSideMenu,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.shifting,
              showSelectedLabels: true,
              iconSize: sp.getWidth(15, screenWidth),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              selectedLabelStyle: AppTextTheme.textTheme.labelSmall!.copyWith(
                color: Colors.white,
              ),
              unselectedLabelStyle: AppTextTheme.textTheme.labelSmall!.copyWith(
                color: Colors.white,
              ),
            )
          : Container(
              color: AppColor.bgSideMenu,
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
                          margin: AppResponsive.isDesktop(context)
                              ? EdgeInsets.all(10)
                              : null,
                          padding: AppResponsive.isDesktop(context)
                              ? EdgeInsets.all(10)
                              : null,
                          decoration: BoxDecoration(
                            color: AppColor.blue.withOpacity(0.5),
                            borderRadius: AppResponsive.isDesktop(context)
                                ? BorderRadius.circular(30)
                                : null,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: sp.getWidth(5, screenWidth)),
                            // tileColor: Colors.white,
                            title: Text(
                                appState.user == null ||
                                        appState.user!.name == ""
                                    ? ""
                                    : "Hello, ${appState.user!.name}",
                                style: AppTextTheme.textTheme.bodyLarge!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Divider(
                                  color: AppColor.bgSideMenu,
                                  thickness: .25,
                                ),
                                Text(
                                    appState.businessInfo == null ||
                                            appState.businessInfo!
                                                    .businessName ==
                                                ""
                                        ? "Lumin Business"
                                        : appState.businessInfo!.businessName,
                                    style: AppTextTheme.textTheme.labelSmall!),
                                SizedBox(
                                  height: sp.getHeight(
                                      2, screenHeight, screenWidth),
                                ),
                                Text(
                                    appState.user == null ||
                                            appState.user!.name == "" ||
                                            appState.user!.access == null
                                        ? ""
                                        : "${appState.user!.access}",
                                    style: AppTextTheme.textTheme.labelSmall!)
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.settings),
                              iconSize: sp.getWidth(20, screenWidth),
                              onPressed: () {},
                            ),
                          ),
                        ),
                  SizedBox(
                    height: screenHeight * 0.175,
                  ),
                  for (Widget w in menuItems) w,
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
                            Provider.of<InventoryProvider>(context,
                                    listen: false)
                                .openOrder
                                .clear();
                            Provider.of<InventoryProvider>(context,
                                    listen: false)
                                .allProdcuts
                                .clear();
                            Navigator.pushReplacementNamed(context, "/sign-in");
                          });
                        }
                      },
                    ),
                  ),
                  appState.user != null && appState.user!.access == "admin"
                      ? menuItemDesktop(
                          title: "Order History",
                          context: context,
                          appState: appState,
                          icon: Icon(Icons.list),
                          hasTrailing: false,
                          press: () {},
                        )
                      : SizedBox(),
                ],
              ),
            );
    });
  }

  BottomNavigationBarItem menuItemTabAndMobile(
      {required String title,
      required Icon icon,
      required AppState appState,
      required BuildContext context,
      required bool hasTrailing}) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
        label: title,
        backgroundColor: AppColor.bgSideMenu);
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
            style: AppTextTheme.textTheme.bodyLarge,
          ),
          trailing: hasTrailing
              ? Icon(
                  Icons.east,
                  size: sp.getWidth(15, screenWidth),
                )
              : null,
        ),
      ),
    );
  }
}
