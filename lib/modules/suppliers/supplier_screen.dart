import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:lumin_business/widgets/add_record.dart';
import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:provider/provider.dart';

class SupplierScreen extends StatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
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

    return Consumer2<SupplierProvider, AppState>(
        builder: (context, supplierProvider, appState, _) {
      if (appState.businessInfo != null) {
        Provider.of<SupplierProvider>(context, listen: false)
            .fetchSuppliers(appState.businessInfo!.businessId);
      }
      return Container(
        margin: EdgeInsets.all(
            sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth)),
        padding: EdgeInsets.only(
          top: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 5, screenWidth),
          bottom: sp.getWidth(sp.isDesktop(screenWidth) ? 10 : 0, screenWidth),
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
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: AppColor.black,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AddRecord<SupplierProvider>(
                              recordType: RecordType.supplier,
                            );
                          });
                    },
                  ),
                  supplierProvider.allSuppliers.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.download,
                            color: AppColor.black,
                          ),
                          onPressed: () async {
                            supplierProvider.downloadSuppliersToCSV();
                          },
                        )
                      : SizedBox(),
                ],
                controller: supplierProvider.allSuppliers.isEmpty
                    ? null
                    : searchController,
                hintText: "Search suppliers",
              ),
            Expanded(
              child: !supplierProvider.isSuppliersFetched
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : supplierProvider.allSuppliers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.peopleCarryBox,
                                color: AppColor.bgSideMenu,
                                size: sp.getWidth(100, screenWidth),
                              ),
                              SizedBox(
                                height:
                                    sp.getHeight(20, screenHeight, screenWidth),
                              ),
                              Text(
                                "You don't have any suppliers yet.\nClick the '+' button, in the top right corner of this window, to add your first supplier",
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
                            supplierProvider.allSuppliers.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase())); //

                            return GeneralListTile.fromSupplier(
                              supplier: appState.searchText.isEmpty
                                  ? supplierProvider.allSuppliers[index]
                                  : supplierProvider.allSuppliers
                                      .where((p) =>
                                          p.name.contains(appState.searchText))
                                      .elementAt(index),
                              appState: appState,
                              provider: supplierProvider,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                              ),
                          itemCount: appState.searchText.isEmpty
                              ? supplierProvider.allSuppliers.length
                              : supplierProvider.allSuppliers
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
                    "",
                    // "Above critical level (${customerProvider.calculateAboveCriticalLevel()})",
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
                    // "Below critical level (${customerProvider.calculateCriticalLevel()})",
                    "",
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
                    // "Out of stock (${customerProvider.calculateOutofStock()})",
                    "",
                    style: textTheme
                        .textTheme(screenWidth)
                        .bodySmall!
                        .copyWith(color: Colors.black),
                  ),
                  Spacer(),
                  Text(
                    // "Product Count: ${customerProvider.allProdcuts.length}",
                    "",
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
                  Text(
                      // "Inventory Count: ${customerProvider.inventoryCount()}",
                      "",
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
