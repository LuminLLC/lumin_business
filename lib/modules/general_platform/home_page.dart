import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/customers/customer_screen.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/accounting/accounts_screen.dart';
import 'package:lumin_business/modules/dashboard/dashboad_screen.dart';
import 'package:lumin_business/modules/settings/settings_screen.dart';
import 'package:lumin_business/modules/suppliers/supplier_screen.dart';
import 'package:provider/provider.dart';
import 'menu_controller.dart';
import '../inventory/inventory_screen.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SizeAndSpacing sp = SizeAndSpacing();
  List<Widget> _view = [
    DashboadScreen(),
    AccountingScreen(),
    InventoryScreen(),
    CustomerScreen(),
    SupplierScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    print(sp.isDesktop(screenWidth));
    return Consumer<AppState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: !sp.isDesktop(screenWidth)
            ? AppBar(
                backgroundColor: AppColor.bgSideMenu,
                title: Text(
                  appState.index == 0
                      ? "Dashboard"
                      : appState.index == 1
                          ? "Accounting"
                          : appState.index == 2
                              ? "Inventory"
                              : appState.index == 3
                                  ? "Customers"
                                  : appState.index == 4
                                      ? "Suppliers"
                                      : "Settings",
                  style: AppTextTheme().textTheme(screenWidth).displayMedium,
                ),
              )
            : null,
        drawer: sp.isDesktop(screenWidth) ? null : Menu(),
        key: Provider.of<PlatformMenuController>(context, listen: false)
            .scaffoldKey,
        backgroundColor: AppColor.bgSideMenu,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sp.isDesktop(screenWidth))
                Container(width: screenWidth * 0.15, child: Menu()),

              /// Main Body Part
              Expanded(child: _view[appState.index]),
            ],
          ),
        ),
      );
    });
  }
}
