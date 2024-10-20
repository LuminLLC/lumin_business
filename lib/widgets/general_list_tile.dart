import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/order_management/order_controller.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:lumin_business/modules/inventory/set_order_quantity.dart';
import 'package:lumin_business/modules/user_and_busness/business_model.dart';
import 'package:lumin_business/widgets/view_record.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GeneralListTile extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
  final AppTextTheme textTheme = AppTextTheme();
  ProductModel? product;
  SupplierModel? supplier;
  CustomerModel? customer;
  BusinessModel? businessInfo;
  int? index;
  List<String>? itemLabels;

  AccountingModel? transaction;
  dynamic provider;
  final AppState appState;

  GeneralListTile.fromProduct(
      {Key? key,
      required this.product,
      required this.appState,
      required this.provider})
      : super(key: key);

  GeneralListTile.fromSupplier(
      {Key? key,
      required this.supplier,
      required this.appState,
      required this.provider})
      : super(key: key);

  GeneralListTile.fromCustomers(
      {Key? key,
      required this.customer,
      required this.appState,
      required this.provider})
      : super(key: key);

  GeneralListTile.fromTransaction(
      {Key? key,
      required this.transaction,
      required this.appState,
      required this.provider})
      : super(key: key);

  GeneralListTile.fromSettings({
    Key? key,
    required this.businessInfo,
    required this.index,
    required this.itemLabels,
    required this.appState,
  }) : super(key: key);

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

    if (product != null) {
      return prodcutTile(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          product: product!,
          context: context);
    } else if (supplier != null) {
      return supplierTile(
          screenHeight: screenHeight,
          supplier: supplier!,
          provider: provider,
          screenWidth: screenWidth,
          context: context);
    } else if (customer != null) {
      return customerTile(
          screenHeight: screenHeight,
          customer: customer!,
          provider: provider,
          screenWidth: screenWidth,
          context: context);
    } else if (transaction != null) {
      return transactionTile(
          screenHeight: screenHeight,
          transaction: transaction!,
          provider: provider,
          screenWidth: screenWidth,
          context: context);
    } else {
      return settingsTile(
          screenHeight: screenHeight,
          businessInfo: businessInfo!,
          index: index!,
          labels: itemLabels!,
          screenWidth: screenWidth,
          context: context);
    }
  }

  Widget supplierTile(
      {required double screenWidth,
      required double screenHeight,
      required dynamic provider,
      required SupplierModel supplier,
      required BuildContext context}) {
    SupplierProvider supplierProvider = provider;
    int index = supplierProvider.allSuppliers.indexOf(supplier) + 1;
    return Container(
      width: double.infinity,
      child: ListTile(
        leading: Container(
          height: sp.getWidth(50, screenWidth),
          width: sp.getWidth(50, screenWidth),
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: textTheme
                .textTheme(screenWidth)
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        title: Text(supplier.name,
            style: textTheme
                .textTheme(screenWidth)
                .bodyLarge!
                .copyWith(color: Colors.black)),
        subtitle: Row(
          children: [
            Text(
              "Email: ${supplier.email}",
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
            if (sp.isDesktop(screenWidth))
              SizedBox(
                  height: sp.getHeight(20, screenHeight, screenWidth),
                  child: VerticalDivider()),
            if (sp.isDesktop(screenWidth))
              Text(
                "Address: ${supplier.address}",
                style: textTheme
                    .textTheme(screenWidth)
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
            if (sp.isDesktop(screenWidth))
              SizedBox(
                  height: sp.getHeight(20, screenHeight, screenWidth),
                  child: VerticalDivider()),
            if (sp.isDesktop(screenWidth))
              Text(
                "Contact: ${supplier.contactNumber}",
                style: textTheme
                    .textTheme(screenWidth)
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.open_in_full,
            size: sp.getWidth(20, screenWidth),
            color: AppColor.bgSideMenu.withOpacity(0.8),
          ),
          onPressed: () {
            showDialog(
                // barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ViewRecord<SupplierProvider>(
                      record: supplier, recordType: RecordType.supplier);
                });
          },
        ),
      ),
    );
  }

  Widget customerTile(
      {required double screenWidth,
      required double screenHeight,
      required CustomerModel customer,
      required dynamic provider,
      required BuildContext context}) {
    CustomerProvider customerProvider = provider;
    int index = customerProvider.allCustomers.indexOf(customer) + 1;
    return Container(
      width: double.infinity,
      child: ListTile(
        leading: Container(
          height: sp.getWidth(50, screenWidth),
          width: sp.getWidth(50, screenWidth),
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: textTheme
                .textTheme(screenWidth)
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        title: Text(customer.name,
            style: textTheme
                .textTheme(screenWidth)
                .bodyLarge!
                .copyWith(color: Colors.black)),
        subtitle: Row(
          children: [
            Text(
              "Email: ${customer.email}",
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
            if (sp.isDesktop(screenWidth))
              SizedBox(
                  height: sp.getHeight(20, screenHeight, screenWidth),
                  child: VerticalDivider()),
            if (sp.isDesktop(screenWidth))
              Text(
                "Address: ${customer.address}",
                style: textTheme
                    .textTheme(screenWidth)
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
            if (sp.isDesktop(screenWidth))
              SizedBox(
                  height: sp.getHeight(20, screenHeight, screenWidth),
                  child: VerticalDivider()),
            if (sp.isDesktop(screenWidth))
              Text(
                "Contact: ${customer.phoneNumber}",
                style: textTheme
                    .textTheme(screenWidth)
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.open_in_full,
            size: sp.getWidth(20, screenWidth),
            color: AppColor.bgSideMenu.withOpacity(0.8),
          ),
          onPressed: () {
            showDialog(
                // barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ViewRecord<CustomerProvider>(
                      record: customer, recordType: RecordType.customer);
                });
          },
        ),
      ),
    );
  }

  Widget transactionTile({
    required double screenWidth,
    required double screenHeight,
    required AccountingModel transaction,
    required dynamic provider,
    required BuildContext context,
  }) {
    AccountingProvider accountingProvider = provider;
    int index = accountingProvider.allTransactions.indexOf(transaction) + 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: sp.getHeight(10, screenHeight, screenWidth)),
      child: ListTile(
        leading: Container(
          height: sp.getWidth(50, screenWidth),
          width: sp.getWidth(50, screenWidth),
          decoration: BoxDecoration(
            color: transaction.type == TransactionType.income
                ? Colors.green
                : Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            index.toString(),
            style: textTheme
                .textTheme(screenWidth)
                .bodyLarge!
                .copyWith(color: Colors.white),
          ),
        ),
        title: Text(
          "GHS${transaction.amount.toStringAsFixed(2)}",
          style: textTheme
              .textTheme(screenWidth)
              .bodyLarge!
              .copyWith(color: Colors.black),
        ),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Description: ${transaction.description}", //
              style: textTheme
                  .textTheme(screenWidth)
                  .bodySmall!
                  .copyWith(color: Colors.black),
            ),
            if (!sp.isMobile(screenWidth))
              SizedBox(
                  height: sp.getHeight(20, screenHeight, screenWidth),
                  child: VerticalDivider()),
            if (!sp.isMobile(screenWidth))
              Text(
                "Date: ${transaction.date}",
                style: textTheme
                    .textTheme(screenWidth)
                    .bodySmall!
                    .copyWith(color: Colors.black),
              ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.open_in_full,
            size: sp.getWidth(20, screenWidth),
            color: AppColor.bgSideMenu.withOpacity(0.8),
          ),
          onPressed: () {
            showDialog(
                // barrierDismissible: false,
                context: context,
                builder: (context) {
                  return ViewRecord<AccountingProvider>(
                      record: transaction, recordType: RecordType.transaction);
                });
          },
        ),
      ),
    );
  }

  Widget prodcutTile(
      {required double screenWidth,
      required double screenHeight,
      required ProductModel product,
      required BuildContext context}) {
    return Consumer2<InventoryProvider, OrderProvider>(
        builder: (context, inventoryProvider, orderProvider, _) {
      int index = inventoryProvider.allProdcuts.indexOf(product) + 1;
      Uint8List? image;
      return Container(
        width: double.infinity,
        child: ListTile(
          leading: product.image == null
              ? Container(
                  height: sp.getWidth(50, screenWidth),
                  width: sp.getWidth(50, screenWidth),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(
                    index.toString(),
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodyLarge!
                        .copyWith(color: Colors.white),
                  ),
                )
              : Container(
                  height: sp.getWidth(50, screenWidth),
                  width: sp.getWidth(50, screenWidth),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(10)),
                  child: Image.memory(
                    image ?? Uint8List.fromList([]),
                    height: sp.getWidth(40, screenWidth),
                    width: sp.getWidth(40, screenWidth),
                  ),
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
              if (sp.isDesktop(screenWidth))
                Text(
                  "Category: ${product.category}",
                  style: textTheme
                      .textTheme(screenWidth)
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
              if (sp.isDesktop(screenWidth))
                SizedBox(
                    height: sp.getHeight(20, screenHeight, screenWidth),
                    child: VerticalDivider()),
              Text(
                "Quantity: ${product.quantity}",
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
          trailing: Container(
            width:
                sp.getWidth(sp.isDesktop(screenWidth) ? 200 : 75, screenWidth),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: sp.getWidth(
                        sp.isDesktop(screenWidth) ? 25 : 15, screenWidth),
                    color: AppColor.bgSideMenu.withOpacity(0.8),
                  ),
                  onPressed: () {
                    // print(product.image.toString());
                    showDialog(
                        // barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return ViewRecord<InventoryProvider>(
                              record: product, recordType: RecordType.product);
                        });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_shopping_cart,
                    size: sp.getWidth(
                        sp.isDesktop(screenWidth) ? 25 : 15, screenWidth),
                    color: getTileColor(product.quantity),
                  ),
                  onPressed: () {
                    if (product.quantity > 0) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SetOrderQuantity(
                              product: product,
                              orderProvider: orderProvider,
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
    });
  }

  Widget settingsTile({
    required double screenWidth,
    required double screenHeight,
    required BusinessModel businessInfo,
    required int index,
    required List<String> labels,
    required BuildContext context,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          vertical: sp.getHeight(10, screenHeight, screenWidth)),
      child: ListTile(
        leading: Text(
          labels.elementAt(index),
          style: textTheme
              .textTheme(screenWidth)
              .bodyLarge!
              .copyWith(color: Colors.black),
        ),
        title: Text(
          businessInfo.toList().elementAt(index),
          style: textTheme
              .textTheme(screenWidth)
              .bodyLarge!
              .copyWith(color: Colors.black),
        ),
        // subtitle: Row(
        //   children: [
        //     Text(
        //       "Amount: GHS${transaction.amount.toStringAsFixed(2)}",
        //       style: textTheme
        //           .textTheme(screenWidth)
        //           .bodySmall!
        //           .copyWith(color: Colors.black),
        //     ),
        //     SizedBox(
        //         height: sp.getHeight(20, screenHeight, screenWidth),
        //         child: VerticalDivider()),
        //     Text(
        //       "Date: ${transaction.date}",
        //       style: textTheme
        //           .textTheme(screenWidth)
        //           .bodySmall!
        //           .copyWith(color: Colors.black),
        //     ),
        //   ],
        // ),
        // trailing: IconButton(
        //   icon: Icon(
        //     Icons.open_in_full,
        //     size: sp.getWidth(20, screenWidth),
        //     color: AppColor.bgSideMenu.withOpacity(0.8),
        //   ),
        //   onPressed: () {
        //     showDialog(
        //         // barrierDismissible: false,
        //         context: context,
        //         builder: (context) {
        //           return SelectedTransaction(
        //             transaction: transaction,
        //             appState: appState,
        //             accountingProvider: provider,
        //           );
        //         });
        //   },
        // ),
      ),
    );
  }
}
