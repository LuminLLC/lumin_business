import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/product_controller.dart';
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
        icon: Icon(Icons.home),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(0);
        },
      ),
      menuItemDesktop(
        title: "Accounts",
        context: context,
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
        appState: appState,
        press: () {
          appState.setIndex(3);
        },
      ),
      menuItemDesktop(
        title: "Suppliers",
        context: context,
        icon: Icon(FontAwesomeIcons.peopleCarryBox),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(4);
        },
      ),
      menuItemDesktop(
        title: "Settings",
        context: context,
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
        press: () {
          appState.setIndex(0);
        },
      ),
      menuItemTabAndMobile(
        title: "Accounts",
        context: context,
        icon: Icon(FontAwesomeIcons.cashRegister),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(1);
        },
      ),
      menuItemTabAndMobile(
        title: "Inventory",
        context: context,
        icon: Icon(FontAwesomeIcons.store),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(2);
        },
      ),
      menuItemTabAndMobile(
        title: "Customers",
        context: context,
        icon: Icon(FontAwesomeIcons.person),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(3);
        },
      ),
      menuItemTabAndMobile(
        title: "Suppliers",
        context: context,
        icon: Icon(FontAwesomeIcons.peopleCarryBox),
        hasTrailing: true,
        appState: appState,
        press: () {
          appState.setIndex(4);
        },
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
          ? BottomNavigationBar(items: menuItemsTabAndMobile)
          : Container(
              color: AppColor.bgSideMenu,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container( 
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    child: Text(
                      appState.businessInfo == null ||
                              appState.businessInfo!.businessName == ""
                          ? "Lumin Business "
                          : appState.businessInfo!.businessName,
                      style: AppTextTheme.textTheme.headlineLarge,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      appState.user == null || appState.user!.name == ""
                          ? ""
                          : "Welcome, ${appState.user!.name}",
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: sp.getFontSize(20, screenWidth),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20, top: 50),
                    child: Text(
                      appState.user == null || appState.user!.name == ""
                          ? ""
                          : "Account type: ${appState.user!.access}",
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: sp.getFontSize(14, screenWidth),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
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
                            Provider.of<ProductController>(context,
                                    listen: false)
                                .openOrder
                                .clear();
                            Provider.of<ProductController>(context,
                                    listen: false)
                                .allProdcuts
                                .clear();
                            Navigator.pushReplacementNamed(context, "/sign-in");
                          });
                        }
                      },
                    ),
                  ),
                  // appState.user != null && appState.user!.access == "admin"
                  //     ? DrawerListTile(
                  //         title: "Inventory",
                  //         icon: "assets/menu_recruitment.png",
                  //         press: () {},
                  //       )
                  //     : SizedBox(),
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

                  // appState.user != null && appState.user!.access == "regular"
                  //     ? ListTile(
                  //         leading: Icon(
                  //           Icons.receipt_long,
                  //           color: AppColor.white,
                  //         ),
                  //         title: Center(
                  //           child: Text(
                  //             "Today's Orders",
                  //             style: TextStyle(color: AppColor.white),
                  //           ),
                  //         ),
                  //       )
                  //     : SizedBox(),
                  // appState.user != null && appState.user!.access == "regular"
                  //     ? Divider()
                  //     : SizedBox(),

                  // appState.user != null && appState.user!.access == "regular"
                  //     ? Padding(
                  //         padding: EdgeInsets.only(
                  //             bottom: sp.getHeight(40, screenHeight, screenWidth)),
                  //         child:
                  //             StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  //                 stream: OrderController().getTodaysOrders(
                  //                     appState.businessInfo!.businessId),
                  //                 builder: (context, snapshot) {
                  //                   print("data here ${snapshot.data}");

                  //                   if (snapshot.data == null ||
                  //                       snapshot.data!.data() == null) {
                  //                     return Center(
                  //                         child: Padding(
                  //                       padding: const EdgeInsets.all(15),
                  //                       child: Text("No Orders Today"),
                  //                     ));
                  //                   } else {
                  //                     return Column(
                  //                       children: [
                  //                         ListView.builder(
                  //                           shrinkWrap: true,
                  //                           itemCount: snapshot.data == null
                  //                               ? 0
                  //                               : snapshot.data!.data()!.length,
                  //                           itemBuilder: (context, index) {
                  //                             if (snapshot.hasError) {
                  //                               return Text("Error");
                  //                             } else if (snapshot.data == null) {
                  //                               return Text("No Orders");
                  //                             } else if (snapshot.hasData) {
                  //                               print("here");
                  //                               return ListTile(
                  //                                 leading: Text(snapshot.data!
                  //                                     .data()!
                  //                                     .keys
                  //                                     .toList()[index]),
                  //                                 title: Text(
                  //                                   "Total: GHS${OrderController().getOrderTotal(snapshot.data!.data()![snapshot.data!.data()!.keys.toList()[index]])}",
                  //                                   style: TextStyle(
                  //                                       color: AppColor.white),
                  //                                 ),
                  //                                 trailing: OrderController()
                  //                                     .getOrderStatus(snapshot.data!
                  //                                             .data()![
                  //                                         snapshot.data!
                  //                                             .data()!
                  //                                             .keys
                  //                                             .toList()[index]]),
                  //                               );
                  //                             } else {
                  //                               return CircularProgressIndicator();
                  //                             }
                  //                           },
                  //                         ),
                  //                         Padding(
                  //                           padding: const EdgeInsets.only(
                  //                               top: 8.0, left: 8, right: 8),
                  //                           child: Divider(),
                  //                         ),
                  //                         Padding(
                  //                           padding:
                  //                               const EdgeInsets.only(bottom: 10.0),
                  //                           child: ListTile(
                  //                             title: Text("Today's Sales:"),
                  //                             trailing: Text(
                  //                                 " GHS${snapshot.data!.data()!.values.map((e) => OrderController().getOrderTotal(e)).reduce((value, element) => value + element)}"),
                  //                           ),
                  //                         )
                  //                       ],
                  //                     );
                  //                   }
                  //                 }),
                  // )
                  // : SizedBox(),
                ],
              ),
            );
    });
  }

  BottomNavigationBarItem menuItemTabAndMobile(
      {required String title,
      required Icon icon,
      required VoidCallback press,
      required AppState appState,
      required BuildContext context,
      required bool hasTrailing}) {
    return BottomNavigationBarItem(
        icon: icon, label: title, backgroundColor: Colors.white);
  }

  Widget menuItemDesktop(
      {required String title,
      required Icon icon,
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
