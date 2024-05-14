import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/screens/inventory/widgets/new_product.dart';
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

  final TextEditingController searchController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Consumer2<ProductController, AppState>(
      builder: (context, productController, appState, _) => Container(
        decoration: BoxDecoration(
            color: AppColor.white, borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(20),
        child: !productController.isProductFetched
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "All Products",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.black,
                          fontSize: sp.getFontSize(22, width),
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
                      // LuminTextIconButton(
                      //   text: "Add Product",
                      //   onPressed: () {
                      //     showDialog(
                      //         context: context,
                      //         builder: (context) {
                      //           return NewProduct(
                      //             productController: productController,
                      //           );
                      //         });
                      //   },
                      //   icon: Icons.add,
                      // ),
                      SizedBox(
                        width: sp.getWidth(20, width),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: sp.getWidth(300, width),
                        height: sp.getHeight(70, height, width),
                        child: SearchBar(
                          controller: searchController,
                          onChanged: (value) {
                            productController.searchProduct(value);
                          },
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                                color: Colors.black,
                                fontSize: sp.getFontSize(16, width)),
                          ),
                          side: MaterialStatePropertyAll(
                            BorderSide(color: Colors.grey),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                            side: BorderSide(
                                color: Colors.black), // Example border side
                          )),
                          leading: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: "Search products by name",
                          hintStyle: MaterialStateProperty.all(
                            TextStyle(
                                color: Colors.grey,
                                fontSize: sp.getFontSize(16, width)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.grey,
                  ),
                  SizedBox(
                      height: height / 2,
                      child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            productController.allProdcuts.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase()));
                            late Product product;
                            if (productController.searchResults.isEmpty) {
                              product = productController.allProdcuts[index];
                            } else {
                              product = productController.searchResults[index];
                            }
                            return ProductListTile(
                              product: product,
                              appState: appState,
                              productController: productController,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[100],
                              ),
                          itemCount: productController.searchResults.isEmpty
                              ? productController.allProdcuts.length
                              : productController.searchResults.length)),
                ],
              ),
      ),
    );
  }
}
