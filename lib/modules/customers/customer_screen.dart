import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:lumin_business/widgets/new_product.dart';
import 'package:lumin_business/widgets/open_order.dart';
import 'package:lumin_business/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final AppTextTheme textTheme = AppTextTheme();
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController searchController;
  late TextEditingController quantityController;
  String searchText = "";
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
        builder: (context, invetoryProvider, appState, _) {
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
            HeaderWidget(),
            Padding(
              padding: EdgeInsets.only(
                  bottom: sp.getHeight(20, screenHeight, screenWidth)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      cursorColor: AppColor.bgSideMenu,
                      onChanged: (s) {
                        setState(() {
                          searchText = s;
                        });
                      },
                      style: textTheme
                          .textTheme(screenWidth)
                          .headlineMedium!
                          .copyWith(color: Colors.black),
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.bgSideMenu),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.bgSideMenu),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColor.bgSideMenu),
                          ),
                          hintStyle: textTheme
                              .textTheme(screenWidth)
                              .bodyLarge!
                              .copyWith(color: Colors.black),
                          hintText: "All Products",
                          suffixIcon: Icon(
                            Icons.search,
                            size: sp.getWidth(25, screenWidth),
                            color: AppColor.bgSideMenu,
                          )),
                    ),
                  ),
                  Spacer(),
                  invetoryProvider.openOrder.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: sp.getWidth(10, screenWidth)),
                          child: LuminTextIconButton(
                            text: "Open Order",
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return OpenOrder(
                                        appState: appState,
                                        inventoryProvider: invetoryProvider);
                                  });
                            },
                            icon: Icons.shopping_bag,
                          ),
                        )
                      : SizedBox(),
                  LuminTextIconButton(
                    text: "Add Product",
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return NewProduct(
                              appState: appState,
                              inventoryProvider: invetoryProvider,
                            );
                          });
                    },
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    //TODO: move this function out of widget tree and factor in different filter options
                    invetoryProvider.allProdcuts.sort((a, b) => a.name
                        .toLowerCase()
                        .compareTo(b.name.toLowerCase())); //

                    return ProductListTile(
                      product: searchText.isEmpty
                          ? invetoryProvider.allProdcuts[index]
                          : invetoryProvider.allProdcuts
                              .where((p) => p.name.contains(searchText))
                              .elementAt(index),
                      appState: appState,
                      inventoryProvider: invetoryProvider,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                      ),
                  itemCount: searchText.isEmpty
                      ? invetoryProvider.allProdcuts.length
                      : invetoryProvider.allProdcuts
                          .where((p) => p.name.contains(searchText))
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
                    "Above critical level (${invetoryProvider.calculateAboveCriticalLevel()})",
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
                    "Below critical level (${invetoryProvider.calculateCriticalLevel()})",
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
                    "Out of stock (${invetoryProvider.calculateOutofStock()})",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    "Product Count: ${invetoryProvider.allProdcuts.length}",
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
                  Text("Inventory Count: ${invetoryProvider.inventoryCount()}",
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
