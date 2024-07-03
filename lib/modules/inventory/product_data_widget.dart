import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';

import 'package:lumin_business/widgets/new_product.dart';
import 'package:lumin_business/widgets/open_order.dart';
import 'package:lumin_business/widgets/lumin_texticon_button.dart';
import 'package:lumin_business/widgets/product_list_tile.dart';
import 'package:provider/provider.dart';

class ProductDataWidget extends StatefulWidget {
  @override
  _ProductDataWidgetState createState() => _ProductDataWidgetState();
}

class _ProductDataWidgetState extends State<ProductDataWidget> {
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Consumer2<InventoryProvider, AppState>(
      builder: (context, InventoryProvider, appState, _) => !InventoryProvider
              .isProductFetched
          ? Column(
              children: [
                SizedBox(
                  height: height / 4.5,
                ),
                CircularProgressIndicator(),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(bottom: sp.getHeight(15, height, width)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (s) {
                            setState(() {
                              searchText = s;
                            });
                          },
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.black,
                            fontSize: sp.getFontSize(22, width),
                          ),
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                                fontSize: sp.getFontSize(22, width),
                              ),
                              hintText: "All Products",
                              suffixIcon: Icon(Icons.search)),
                        ),
                      ),
                      Spacer(),
                      InventoryProvider.openOrder.isNotEmpty
                          ? TextButton.icon(
                              onPressed: () {
                                print(InventoryProvider.fetchOpenOrder());
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return OpenOrder(
                                          appState: appState,
                                          inventoryProvider: InventoryProvider);
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
                                  inventoryProvider: InventoryProvider,
                                );
                              });
                        },
                        icon: Icons.add,
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      //TODO: move this function out of widget tree and factor in different filter options
                      InventoryProvider.allProdcuts.sort((a, b) => a.name
                          .toLowerCase()
                          .compareTo(b.name.toLowerCase())); //

                      return ProductListTile(
                        product: searchText.isEmpty
                            ? InventoryProvider.allProdcuts[index]
                            : InventoryProvider.allProdcuts
                                .where((p) => p.name.contains(searchText))
                                .elementAt(index),
                        appState: appState,
                        inventoryProvider: InventoryProvider,
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[300],
                        ),
                    itemCount: searchText.isEmpty
                        ? InventoryProvider.allProdcuts.length
                        : InventoryProvider.allProdcuts
                            .where((p) => p.name.contains(searchText))
                            .length),
              ],
            ),
    );
  }
}
