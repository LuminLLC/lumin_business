import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';

import 'package:lumin_business/modules/inventory/product.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/set_order_quantity.dart';
import 'package:lumin_business/widgets/selected_product.dart';

class ProductListTile extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
  final AppTextTheme textTheme = AppTextTheme();
  final Product product;
  final InventoryProvider inventoryProvider;
  final AppState appState;
  ProductListTile(
      {Key? key,
      required this.product,
      required this.appState,
      required this.inventoryProvider})
      : super(key: key);

  Color getTileColor(int quantity) {
    if (quantity > 10) {
      return Colors.green;
    } else if (quantity == 0) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      // color: getTileColor(product.quantity),
      width: double.infinity,
      child: ListTile(
        leading: product.image == null
            ? Container(
                height: sp.getWidth(50, screenWidth),
                width: sp.getWidth(50, screenWidth),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10)),
              )
            : Image.network(
                product.image!,
                height: sp.getWidth(50, screenWidth),
                width: sp.getWidth(50, screenWidth),
              ),
        title: Row(
          children: [
            Text(product.name,
                style: textTheme
                    .textTheme(screenWidth)
                    .bodyLarge!
                    .copyWith(color: Colors.black)),
            SizedBox(
              width: 20,
            ),
            Container(
              height: sp.getWidth(10, screenWidth),
              width: sp.getWidth(10, screenWidth),
              color: getTileColor(product.quantity),
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(
              "Category: ${product.category}",
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(
                height: sp.getHeight(20, screenHeight, screenWidth),
                child: VerticalDivider()),
            Text(
              "Quantity in stock: ${product.quantity}",
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
            SizedBox(
                height: sp.getHeight(20, screenHeight, screenWidth),
                child: VerticalDivider()),
            Text(
              "Price: GHS${product.unitPrice}",
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        trailing: SizedBox(
          width: sp.getWidth(200, screenWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  size: sp.getWidth(25, screenWidth),
                  color: AppColor.bgSideMenu.withOpacity(0.8),
                ),
                onPressed: () {
                  showDialog(
                      // barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return SelectedProduct(
                          product: product,
                          appState: appState,
                          inventoryProvider: inventoryProvider,
                        );
                      });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  size: sp.getWidth(25, screenWidth),
                  color: getTileColor(product.quantity),
                ),
                onPressed: () {
                  if (product.quantity > 0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SetOrderQuantity(
                            product: product,
                            inventoryProvider: inventoryProvider,
                          );
                        });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
