import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/product_controller.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/widgets/set_order_quantity.dart';
import 'package:lumin_business/widgets/selected_product.dart';

class ProductListTile extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();

  final Product product;
  final ProductController productController;
  final AppState appState;
  ProductListTile(
      {Key? key,
      required this.product,
      required this.appState,
      required this.productController})
      : super(key: key);

  Color getTileColor(int quantity) {
    if (quantity > 10) {
      return Colors.green;
    } else if (quantity == 0) {
      return Colors.red.shade100;
    } else {
      return Colors.yellow.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      // color: getTileColor(product.quantity),
      width: double.infinity,
      child: ListTile(
       
        leading: Container(
          height: 10,
          width: 10,
          color: getTileColor(product.quantity),
        ),
    
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColor.black,
            fontSize: sp.getFontSize(16, width),
          ),
        ),
        subtitle: Row(
          children: [
            Text(
              "Category: ${product.category}",
              style: TextStyle(
                color: Colors.black,
                fontSize: sp.getFontSize(14, width),
              ),
            ),
            SizedBox(
                height: sp.getHeight(20, height, width),
                child: VerticalDivider()),
            Text(
              "Quantity in stock: ${product.quantity}",
              style: TextStyle(
                color: Colors.black,
                fontSize: sp.getFontSize(14, width),
              ),
            ),
            SizedBox(
                height: sp.getHeight(20, height, width),
                child: VerticalDivider()),
            Text(
              "Price: GHS${product.unitPrice}",
              style: TextStyle(
                color: Colors.black,
                fontSize: sp.getFontSize(14, width),
              ),
            ),
          ],
        ),
        trailing: SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: AppColor.bgSideMenu,
                ),
                onPressed: () {
                     showDialog(
              // barrierDismissible: false,
              context: context,
              builder: (context) {
                return SelectedProduct(
                  product: product,
                  appState: appState,
                  productController: productController,
                );
              });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: product.quantity == 0 ? Colors.grey : Colors.green,
                ),
                onPressed: () {
                  if (product.quantity > 0) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SetOrderQuantity(
                            product: product,
                            productController: productController,
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
