import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool isSigningOut = false;
  List<Widget> menuItems = [];

  @override
  void initState() {
    super.initState();
  }

  void _getMenuItems(BuildContext context) {
    menuItems = [
      menuItem(
        title: "Dashboard",
        context: context,
        icon: Icon(Icons.home),
        // trailing: Text("Coming Soon"),
        hasTrailing: true,
        press: () {},
      ),
      menuItem(
        title: "Accounts",
        context: context,
        icon: Icon(FontAwesomeIcons.cashRegister),
        hasTrailing: true,
        press: () {},
      ),
      menuItem(
        title: "Inventory",
        context: context,
        icon: Icon(FontAwesomeIcons.store),
        hasTrailing: true,
        press: () {},
      ),
      menuItem(
        title: "Customers",
        context: context,
        icon: Icon(FontAwesomeIcons.person),
        hasTrailing: true,
        press: () {},
      ),
      menuItem(
        title: "Suppliers",
        context: context,
        icon: Icon(FontAwesomeIcons.peopleCarryBox),
        hasTrailing: true,
        press: () {},
      ),
      menuItem(
        title: "Settings",
        context: context,
        icon: Icon(Icons.settings),
        hasTrailing: true,
        press: () {},
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: false).fetchUser(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<AppState>(builder: (context, appState, _) {
      _getMenuItems(context);
      return !AppResponsive.isDesktop(context)
          ? BottomNavigationBar(items: [
              BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Some"),
              BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Some"),
              BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Some"),
              BottomNavigationBarItem(icon: Icon(Icons.abc), label: "Some")
            ])
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
                          ? "Lumin Business"
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
                    child: menuItem(
                      title: "Logout",
                      context: context,
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
                      ? menuItem(
                          title: "Order History",
                          context: context,
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

  Widget menuItem(
      {required String title,
      required Icon icon,
      required VoidCallback press,
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
