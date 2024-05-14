import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/order_controller.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:lumin_business/models/lumin_order.dart';
import 'package:provider/provider.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final SizeAndSpacing sp = SizeAndSpacing();
  bool isSigningOut = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppState>(context, listen: false).fetchUser(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Drawer(
      elevation: 0,
      child: Consumer<AppState>(builder: (context, appState, _) {
        // String? accountType = appState.user!.access;
        // String? businessName = appState.businessInfo!.businessName;
        // String? userName = appState.user!.name;
        return Container(
          color: AppColor.bgSideMenu,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Text(
                      appState.businessInfo == null ||
                              appState.businessInfo!.businessName == ""
                          ? "Lumin Business"
                          : appState.businessInfo!.businessName,
                      style: TextStyle(
                        color: AppColor.yellow,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
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
                      icon: isSigningOut
                          ? SizedBox(
                              height:
                                  sp.getHeight(20, screenHeight, screenWidth),
                              width:
                                  sp.getHeight(20, screenHeight, screenWidth),
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 1,
                              ))
                          : Image.asset(
                              "assets/menu_logout.png",
                              color: Colors.red,
                            ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                height: 50,
              ),
              // DrawerListTile(
              //   title: "Dashboard",
              //   icon: "assets/menu_home.png",
              //   trailing: Text("Coming Soon"),
              //   press: () {},
              // ),
              appState.user != null && appState.user!.access == "admin"
                  ? DrawerListTile(
                      title: "Inventory",
                      icon: "assets/menu_recruitment.png",
                      press: () {},
                    )
                  : SizedBox(),
              appState.user != null && appState.user!.access == "admin"
                  ? DrawerListTile(
                      title: "Order History",
                      icon: "assets/menu_onboarding.png",
                      trailing: Text("Coming Soon"),
                      press: () {},
                    )
                  : SizedBox(),

              appState.user != null && appState.user!.access == "regular"
                  ? ListTile(
                      leading: Icon(
                        Icons.receipt_long,
                        color: AppColor.white,
                      ),
                      title: Center(
                        child: Text(
                          "Today's Orders",
                          style: TextStyle(color: AppColor.white),
                        ),
                      ),
                    )
                  : SizedBox(),
              appState.user != null && appState.user!.access == "regular"
                  ? Divider()
                  : SizedBox(),

              appState.user != null && appState.user!.access == "regular"
                  ? Padding(
                      padding: EdgeInsets.only(
                          bottom: sp.getHeight(40, screenHeight, screenWidth)),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: OrderController().getTodaysOrders(
                                  appState.businessInfo!.businessId),
                              builder: (context, snapshot) {
                                print("data here ${snapshot.data}");

                                if (snapshot.data == null ||
                                    snapshot.data!.data() == null) {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Text("No Orders Today"),
                                  ));
                                } else {
                                  return Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: snapshot.data == null
                                            ? 0
                                            : snapshot.data!.data()!.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.hasError) {
                                            return Text("Error");
                                          } else if (snapshot.data == null) {
                                            return Text("No Orders");
                                          } else if (snapshot.hasData) {
                                            print("here");
                                            return ListTile(
                                              leading: Text(snapshot.data!
                                                  .data()!
                                                  .keys
                                                  .toList()[index]),
                                              title: Text(
                                                "Total: GHS${OrderController().getOrderTotal(snapshot.data!.data()![snapshot.data!.data()!.keys.toList()[index]])}",
                                                style: TextStyle(
                                                    color: AppColor.white),
                                              ),
                                              trailing: OrderController()
                                                  .getOrderStatus(snapshot.data!
                                                          .data()![
                                                      snapshot.data!
                                                          .data()!
                                                          .keys
                                                          .toList()[index]]),
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 8, right: 8),
                                        child: Divider(),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: ListTile(
                                          title: Text("Today's Sales:"),
                                          trailing: Text(
                                              " GHS${snapshot.data!.data()!.values.map((e) => OrderController().getOrderTotal(e)).reduce((value, element) => value + element)}"),
                                        ),
                                      )
                                    ],
                                  );
                                }
                              }),
                    )
                  : SizedBox(),

              // Spacer(),
              // Center(
              //   child: Image.asset(
              //     "assets/logo_white_nobg.png",
              //     height: sp.getWidth(200, screenWidth),
              //     // height: sp.getHeight(500, screenHeight, screenWidth),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  final String title, icon;
  final VoidCallback press;
  Widget? trailing;

  DrawerListTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.press,
      this.trailing})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        icon,
        color: AppColor.white,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColor.white),
      ),
      trailing: trailing,
    );
  }
}
