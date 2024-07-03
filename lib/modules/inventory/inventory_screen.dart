import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:lumin_business/widgets/new_product.dart';
import 'package:lumin_business/widgets/open_order.dart';
import 'package:lumin_business/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';
import '../general_platform/header_widget.dart';
import 'stat_card.dart';
import 'product_data_widget.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
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
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Consumer2<ProductController, AppState>(
        builder: (context, productController, appState, _) {
      return Container(
        margin: AppResponsive.isDesktop(context) ? EdgeInsets.all(20) : null,
        padding: AppResponsive.isDesktop(context) ? EdgeInsets.all(20) : null,
        decoration: BoxDecoration(
          color: AppColor.bgColor,
          borderRadius: AppResponsive.isDesktop(context)
              ? BorderRadius.circular(30)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: sp.getHeight(15, height, width)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width / 3.5,
                    child: Expanded(
                      child: TextField(
                        controller: searchController,
                        cursorColor: AppColor.bgSideMenu,
                        onChanged: (s) {
                          setState(() {
                            searchText = s;
                          });
                        },
                        style: AppTextTheme.textTheme.headlineMedium!
                                .copyWith(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColor.bgSideMenu),
                            ),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColor.bgSideMenu),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColor.bgSideMenu),
                            ),
                            hintStyle: AppTextTheme.textTheme.headlineMedium!
                                .copyWith(color: Colors.black),
                            hintText: "All Products",
                            suffixIcon: Icon(
                              Icons.search,
                              size: sp.getWidth(20, width),
                              color: AppColor.bgSideMenu,
                            )),
                      ),
                    ),
                  ),
                  Spacer(),
                  productController.openOrder.isNotEmpty
                      ? TextButton.icon(
                          onPressed: () {
                            print(productController.fetchOpenOrder());
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return OpenOrder(
                                      appState: appState,
                                      productController: productController);
                                });
                          },
                          label: Text(
                            "View Open Order",
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(Icons.shopping_bag),
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
                              productController: productController,
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
                    productController.allProdcuts.sort((a, b) => a.name
                        .toLowerCase()
                        .compareTo(b.name.toLowerCase())); //

                    return ProductListTile(
                      product: searchText.isEmpty
                          ? productController.allProdcuts[index]
                          : productController.allProdcuts
                              .where((p) => p.name.contains(searchText))
                              .elementAt(index),
                      appState: appState,
                      productController: productController,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[300],
                      ),
                  itemCount: searchText.isEmpty
                      ? productController.allProdcuts.length
                      : productController.allProdcuts
                          .where((p) => p.name.contains(searchText))
                          .length),
            ),
            SizedBox(height: sp.getHeight(10, height, width)),
            Padding(
              padding: EdgeInsets.only(right: width / 4),
              child: Divider(
                color: AppColor.bgSideMenu.withOpacity(0.3),
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Above critical level",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade100,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Below critical level",
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    height: 20,
                    child: VerticalDivider(
                      color: Colors.grey,
                    ),
                  ),
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Out of stock",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
