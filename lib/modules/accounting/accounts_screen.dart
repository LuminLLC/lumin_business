import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/accounting/transaction_model.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/widgets/add_record.dart';
import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:provider/provider.dart';

class AccountingScreen extends StatefulWidget {
  @override
  _AccountingScreenState createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
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

    return Consumer2<AccountingProvider, AppState>(
        builder: (context, accountingProvider, appState, _) {
      if (appState.businessInfo != null) {
        Provider.of<AccountingProvider>(context, listen: false)
            .fetchTransactions(appState.businessInfo!.businessId);
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
                            return AddRecord<AccountingProvider>(
                              recordType: RecordType.transaction,
                            );
                          });
                      // showDialog(
                      //     context: context,
                      //     builder: (context) {
                      //       return NewTransaction(
                      //         appState: appState,
                      //       );
                      //     });
                    },
                  ),
                  accountingProvider.allTransactions.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.download,
                            color: AppColor.black,
                          ),
                          onPressed: () async {
                            List<String> products = [];
                            for (TransactionModel p
                                in accountingProvider.allTransactions) {
                              products.add(p.toString());
                            }
                            if (!generatingPDF &&
                                accountingProvider.allTransactions.isNotEmpty) {
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
                controller: accountingProvider.allTransactions.isEmpty
                    ? null
                    : searchController,
                hintText: "Search transactions",
              ),
            Expanded(
              child: !accountingProvider.isAccountingFetched
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : accountingProvider.allTransactions.isEmpty
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
                            accountingProvider.allTransactions.sort((a, b) => a
                                .description
                                .toLowerCase()
                                .compareTo(b.description.toLowerCase())); //

                            return GeneralListTile.fromTransaction(
                              transaction: appState.searchText.isEmpty
                                  ? accountingProvider.allTransactions[index]
                                  : accountingProvider.allTransactions
                                      .where((p) => p.description
                                          .toLowerCase()
                                          .contains(appState.searchText))
                                      .elementAt(index),
                              appState: appState,
                              provider: accountingProvider,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                              ),
                          itemCount: appState.searchText.isEmpty
                              ? accountingProvider.allTransactions.length
                              : accountingProvider.allTransactions
                                  .where((p) => p.description
                                      .toLowerCase()
                                      .contains(appState.searchText))
                                  .length),
            ),
            SizedBox(height: sp.getHeight(30, screenHeight, screenWidth)),
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                      "Income  ",
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
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Expenses",
                      style: textTheme
                          .textTheme(screenWidth)
                          .bodySmall!
                          .copyWith(color: Colors.black),
                    ),
                    Spacer(),
                    if (sp.isDesktop(screenWidth))
                      Text(
                        "Transaction Count: ${accountingProvider.allTransactions.length}",
                        style: textTheme
                            .textTheme(screenWidth)
                            .bodySmall!
                            .copyWith(color: Colors.black),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
