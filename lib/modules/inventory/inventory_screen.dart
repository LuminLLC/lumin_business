import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/add_record.dart';

import 'package:lumin_business/widgets/general_list_tile.dart';
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

    return Consumer2<InventoryProvider, AppState>(
        builder: (context, inventoryProvider, appState, _) {
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
                          List<String> products = [];
                          for (ProductModel p
                              in inventoryProvider.allProdcuts) {
                            products.add(p.toFormattedString());
                          }
                          if (!generatingPDF &&
                              inventoryProvider.allProdcuts.isNotEmpty) {
                            setState(() {
                              generatingPDF = true;
                            });
                            appState.createPdfAndDownload(products);
                            setState(() {
                              generatingPDF = false;
                            });
                          }
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
                    "Above critical level (${inventoryProvider.calculateAboveCriticalLevel()})",
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
                  Text(
                    "Product Count: ${inventoryProvider.allProdcuts.length}",
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
                  Text("Inventory Count: ${inventoryProvider.inventoryCount()}",
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
