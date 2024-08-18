import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart'; 
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/widgets/add_record.dart';
import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final AppTextTheme textTheme = AppTextTheme();
  bool generatingPDF = false;
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController searchController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    quantityController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer2<CustomerProvider, AppState>(
        builder: (context, customerProvider, appState, _) {
      if (appState.businessInfo != null) {
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchCustomers(appState.businessInfo!.businessId);
      }
      return Container(
        margin: EdgeInsets.all(sp.getWidth(20, screenWidth)),
        padding: EdgeInsets.all(sp.getWidth(20, screenWidth)),
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius:
              sp.isDesktop(screenWidth) ? BorderRadius.circular(30) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.add,
                    color: AppColor.black,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AddRecord<CustomerProvider>(
                            recordType: RecordType.customer,
                          );
                        });
                  },
                ),
                customerProvider.allCustomers.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.download,
                          color: AppColor.black,
                        ),
                        onPressed: () async {
                          // List<String> products = [];
                          // for (CustomerModel c
                          //     in customerProvider.allCustomers) {
                          //   // products.add(p.toFormattedString());
                          // }
                          // if (!generatingPDF &&
                          //     customerProvider.allCustomers.isNotEmpty) {
                          //   setState(() {
                          //     generatingPDF = true;
                          //   });
                          //   appState.createPdfAndDownload(products);
                          //   setState(() {
                          //     generatingPDF = false;
                          //   });
                          // }
                        },
                      )
                    : SizedBox(),
              ],
              controller: customerProvider.allCustomers.isEmpty
                  ? null
                  : searchController,
              hintText: "Search customers",
            ),
            Expanded(
              child: !customerProvider.isCustomersFetched
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : customerProvider.allCustomers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.person,
                                color: AppColor.bgSideMenu,
                                size: sp.getWidth(100, screenWidth),
                              ),
                              SizedBox(
                                height:
                                    sp.getHeight(20, screenHeight, screenWidth),
                              ),
                              Text(
                                "You don't have any customers yet.\nClick the '+' button, in the top right corner of this window, to add your first customer",
                                textAlign: TextAlign.center,
                                style: AppTextTheme()
                                    .textTheme(screenWidth)
                                    .bodyMedium!
                                    .copyWith(
                                      color: AppColor.bgSideMenu,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            //TODO: move this function out of widget tree and factor in different filter options
                            customerProvider.allCustomers.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase())); //

                            return GeneralListTile.fromCustomers(
                              customer: appState.searchText.isEmpty
                                  ? customerProvider.allCustomers[index]
                                  : customerProvider.allCustomers
                                      .where((p) =>
                                          p.name.contains(appState.searchText))
                                      .elementAt(index),
                              appState: appState,
                              provider: customerProvider,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                              ),
                          itemCount: appState.searchText.isEmpty
                              ? customerProvider.allCustomers.length
                              : customerProvider.allCustomers
                                  .where((p) =>
                                      p.name.contains(appState.searchText))
                                  .length),
            ),
            SizedBox(height: sp.getHeight(30, screenHeight, screenWidth)),
            SizedBox(
              child: Row(
                children: [
                  Container(
                    height: sp.getWidth(10, screenWidth),
                    width: sp.getWidth(10, screenWidth),
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "",
                    // "Above critical level (${customerProvider.calculateAboveCriticalLevel()})",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    height: sp.getHeight(20, screenHeight, screenWidth),
                    child: VerticalDivider(
                      color: AppColor.bgSideMenu.withOpacity(0.3),
                    ),
                  ),
                  Container(
                    height: sp.getWidth(10, screenWidth),
                    width: sp.getWidth(10, screenWidth),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    // "Below critical level (${customerProvider.calculateCriticalLevel()})",
                    "",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    height: sp.getHeight(20, screenHeight, screenWidth),
                    child: VerticalDivider(
                      color: AppColor.bgSideMenu.withOpacity(0.3),
                    ),
                  ),
                  Container(
                    height: sp.getWidth(10, screenWidth),
                    width: sp.getWidth(10, screenWidth),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    // "Out of stock (${customerProvider.calculateOutofStock()})",
                    "",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    // "Product Count: ${customerProvider.allProdcuts.length}",
                    "",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    height: sp.getHeight(20, screenHeight, screenWidth),
                    child: VerticalDivider(
                      color: AppColor.bgSideMenu.withOpacity(0.3),
                    ),
                  ),
                  Text(
                      // "Inventory Count: ${customerProvider.inventoryCount()}",
                      "",
                      style: textTheme
                          .textTheme(screenWidth)
                          .bodySmall!
                          .copyWith(color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
