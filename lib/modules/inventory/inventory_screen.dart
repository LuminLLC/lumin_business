import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/order_management/order_controller.dart';
import 'package:lumin_business/widgets/add_record.dart';

import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:lumin_business/widgets/open_order.dart';
import 'package:provider/provider.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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

    return Consumer3<InventoryProvider, OrderProvider, AppState>(
        builder: (context, inventoryProvider, orderProvider, appState, _) {
      return Container(
        margin: EdgeInsets.all(
            sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth)),
        padding: EdgeInsets.only(
          top: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 5, screenWidth),
          bottom: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 5, screenWidth),
          left: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
          right: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
        ),
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius:
              sp.isDesktop(screenWidth) ? BorderRadius.circular(30) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (sp.isDesktop(screenWidth))
              HeaderWidget(
                actions: [
                  orderProvider.openOrder != null
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return OpenOrder(
                                      orderProvider: orderProvider,
                                      appState: appState);
                                });
                          },
                          icon: Icon(
                            Icons.shopping_cart,
                            color: AppColor.black,
                          ))
                      : SizedBox(),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AddRecord<InventoryProvider>(
                              recordType: RecordType.product,
                            );
                          });
                    },
                  ),
                  inventoryProvider.allProdcuts.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.download,
                            color: AppColor.black,
                          ),
                          onPressed: () async {
                            inventoryProvider.downloadProductsToCSV();
                          },
                        )
                      : SizedBox(),
                ],
                controller: inventoryProvider.allProdcuts.isEmpty
                    ? null
                    : searchController,
                hintText: "Search products",
              ),
            Expanded(
              child: !inventoryProvider.isProductFetched
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : inventoryProvider.allProdcuts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.boxOpen,
                                color: AppColor.bgSideMenu,
                                size: sp.getWidth(100, screenWidth),
                              ),
                              SizedBox(
                                height:
                                    sp.getHeight(20, screenHeight, screenWidth),
                              ),
                              Text(
                                "You don't have any products in your inventory yet.\nClick the '+' button, in the top right corner of this window, to add your first product",
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
                            inventoryProvider.allProdcuts.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase())); //

                            return GeneralListTile.fromProduct(
                              product: appState.searchText.isEmpty
                                  ? inventoryProvider.allProdcuts[index]
                                  : inventoryProvider.allProdcuts
                                      .where((p) => p.name
                                          .toLowerCase()
                                          .contains(appState.searchText))
                                      .elementAt(index),
                              appState: appState,
                              provider: inventoryProvider,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                              ),
                          itemCount: appState.searchText.isEmpty
                              ? inventoryProvider.allProdcuts.length
                              : inventoryProvider.allProdcuts
                                  .where((p) => p.name
                                      .toLowerCase()
                                      .contains(appState.searchText))
                                  .length),
            ),
            SizedBox(height: sp.getHeight(30, screenHeight, screenWidth)),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (sp.isDesktop(screenWidth))
                      Container(
                        height: sp.getWidth(10, screenWidth),
                        width: sp.getWidth(10, screenWidth),
                        decoration: BoxDecoration(
                          color: Colors.green,
                        ),
                      ),
                    if (sp.isDesktop(screenWidth))
                      SizedBox(
                        width: 10,
                      ),
                    if (sp.isDesktop(screenWidth))
                      Text(
                        "Above critical level (${inventoryProvider.calculateAboveCriticalLevel()})",
                        style: textTheme
                            .textTheme(screenWidth)
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    if (sp.isDesktop(screenWidth))
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
                      "Below critical level (${inventoryProvider.calculateCriticalLevel()})",
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
                      "Out of stock (${inventoryProvider.calculateOutofStock()})",
                      style: textTheme
                          .textTheme(screenWidth)
                          .bodySmall!
                          .copyWith(color: Colors.black),
                    ),
                    Spacer(),
                    if (sp.isDesktop(screenWidth))
                      Text(
                        "Product Count: ${inventoryProvider.allProdcuts.length}",
                        style: textTheme
                            .textTheme(screenWidth)
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                    if (sp.isDesktop(screenWidth))
                      SizedBox(
                        height: sp.getHeight(20, screenHeight, screenWidth),
                        child: VerticalDivider(
                          color: AppColor.bgSideMenu.withOpacity(0.3),
                        ),
                      ),
                    if (sp.isDesktop(screenWidth))
                      Text(
                          "Inventory Count: ${inventoryProvider.inventoryCount()}",
                          style: textTheme
                              .textTheme(screenWidth)
                              .bodySmall!
                              .copyWith(color: Colors.black))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
