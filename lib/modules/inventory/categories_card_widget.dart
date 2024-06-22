import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart'; 
import 'package:lumin_business/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class CategoriesCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child:
          Consumer<ProductController>(builder: (context, productController, _) {
        return Column(
          children: [
            ListTile(
              leading: Checkbox(value: false, onChanged: (newValue) {}),
              title: Text(
                "Product Categories",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.black,
                  fontSize: 22,
                ),
              ),
            ),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(
              height: height / 2.5,
              child: ListView.builder(
                itemCount: productController.productCategories.length,
                itemBuilder: ((context, index) {
                  return categoryTile(
                      productController.productCategories[index].name, 10);
                }),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget categoryTile(String text, int count) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Checkbox(value: false, onChanged: (newValue) {}),
          title: Text(
            text,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppColor.black),
          ),
          trailing: Text(
            "$count",
            style:
                TextStyle(fontWeight: FontWeight.bold, color: AppColor.black),
          ),
        ));
  }
}
