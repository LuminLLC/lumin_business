import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/customers/customer_screen.dart';
import 'package:lumin_business/providers/app_state.dart';
import 'package:lumin_business/modules/accounting/accounts_screen.dart';
import 'package:lumin_business/modules/dashboard/dashboad_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/menu_controller.dart';
import '../inventory/inventory_screen.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _controller = PageController();
  final SizeAndSpacing sp = SizeAndSpacing();
  List<Widget> _view = [
    DashboadScreen(),
    AccountingScreen(),
    InventoryScreen(),
    CustomerScreen(),
    DashboadScreen(),
    AccountingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    // final double screenHeight = MediaQuery.of(context).size.height;
    print(sp.isDesktop(screenWidth));
    return Consumer<AppState>(builder: (context, appState, _) {
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
              Expanded(child: _view[appState.index]),
            ],
          ),
        ),
      );
    });
  }
}
