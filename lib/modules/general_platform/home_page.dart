import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/customers/customer_screen.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/accounting/accounting_screen.dart';
import 'package:lumin_business/modules/dashboard/dashboad_screen.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/settings/settings_screen.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:lumin_business/modules/suppliers/supplier_screen.dart';
import 'package:lumin_business/widgets/add_record.dart';
import 'package:provider/provider.dart';
import 'menu_controller.dart';
import '../inventory/inventory_screen.dart';
import 'menu.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearchPressed = false;
  late TextEditingController searchController;
  List<String> titles = [
    "Dashboard",
    "Accounting",
    "Inventory",
    "Customers",
    "Supplier",
    "Settings"
  ];
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
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AppState>(builder: (context, appState, _) {
      return Scaffold(
        appBar: appState.index == !sp.isDesktop(screenWidth)
            ? AppBar(
                backgroundColor:
                    isSearchPressed ? Colors.grey[100] : AppColor.bgSideMenu,
                centerTitle: true,
                actions: [
                  appState.index != 0 &&
                          appState.index != titles.indexOf(titles.last)
                      ? Padding(
                          padding: EdgeInsets.only(
                              right: sp.getWidth(8, screenWidth)),
                          child: IconButton(
                            icon: Icon(
                              isSearchPressed ? Icons.cancel : Icons.search,
                              color: isSearchPressed ? Colors.black : null,
                            ),
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                isSearchPressed = !isSearchPressed;
                              });
                            },
                          ),
                        )
                      : SizedBox()
                ],
                title: isSearchPressed &&
                        appState.index != 0 &&
                        appState.index != titles.indexOf(titles.last)
                    ? SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: appState.index == null
                            ? null
                            : SearchBar(
                                controller: searchController,
                                onChanged: (newText) {
                                  appState.setSearchText(newText.toLowerCase());
                                },
                                textStyle: WidgetStatePropertyAll(AppTextTheme()
                                    .textTheme(screenWidth)
                                    .bodyLarge!
                                    .copyWith(color: AppColor.bgSideMenu)),
                                leading: Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.search,
                                    color: AppColor.bgSideMenu,
                                  ),
                                ),
                                hintText:
                                    "Search ${titles[appState.index!].toLowerCase()}",
                                backgroundColor:
                                    WidgetStatePropertyAll(Colors.grey[100]),
                                elevation: WidgetStatePropertyAll(0),
                                shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                      )
                    : appState.index == null
                        ? SizedBox()
                        : Text(
                            titles[appState.index!],
                            style: AppTextTheme()
                                .textTheme(screenWidth)
                                .displaySmall,
                          ),
              )
            : null,
        drawer: isSearchPressed
            ? null
            : sp.isDesktop(screenWidth)
                ? null
                : Menu(),
        key: Provider.of<PlatformMenuController>(context, listen: false)
            .scaffoldKey,
        floatingActionButton: appState.index == null
            ? null
            : !sp.isDesktop(screenWidth) &&
                    appState.index! > 0 &&
                    appState.index! < 5
                ? FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            switch (appState.index) {
                              case 1:
                                return AddRecord<AccountingProvider>(
                                  recordType: RecordType.transaction,
                                );
                              case 2:
                                return AddRecord<InventoryProvider>(
                                  recordType: RecordType.product,
                                );
                              case 3:
                                return AddRecord<CustomerProvider>(
                                  recordType: RecordType.customer,
                                );
                              case 4:
                                return AddRecord<SupplierProvider>(
                                  recordType: RecordType.supplier,
                                );
                              default:
                            }
                            return AddRecord<AccountingProvider>(
                              recordType: RecordType.transaction,
                            );
                          });
                    },
                    child: Icon(Icons.add),
                  )
                : null,
        backgroundColor: AppColor.bgSideMenu,
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sp.isDesktop(screenWidth))
                Container(width: screenWidth * 0.15, child: Menu()),

              /// Main Body Part
              appState.index == null
                  ? Expanded(child: Center(child: CircularProgressIndicator.adaptive()))
                  : Expanded(child: _view[appState.index!]),
            ],
          ),
        ),
      );
    });
  }
}
