import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/widgets/add_record.dart';
import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:provider/provider.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
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

    return Consumer2<CustomerProvider, AppState>(
        builder: (context, customerProvider, appState, _) {
      if (appState.businessInfo != null) {
        Provider.of<CustomerProvider>(context, listen: false)
            .fetchCustomers(appState.businessInfo!.businessId);
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
                            return AddRecord<CustomerProvider>(
                              recordType: RecordType.customer,
                            );
                          });
                    },
                  ),
                  customerProvider.allCustomers.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.download,
                            color: AppColor.black,
                          ),
                          onPressed: () async {
                            customerProvider.downloadCustomersToCSV();
                          },
                        )
                      : SizedBox(),
                ],
                controller: customerProvider.allCustomers.isEmpty
                    ? null
                    : searchController,
                hintText: "Search customers",
              ),
            Expanded(
              child: !customerProvider.isCustomersFetched
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : customerProvider.allCustomers.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.person,
                                color: AppColor.bgSideMenu,
                                size: sp.getWidth(100, screenWidth),
                              ),
                              SizedBox(
                                height:
                                    sp.getHeight(20, screenHeight, screenWidth),
                              ),
                              Text(
                                "You don't have any customers yet.\nClick the '+' button, in the top right corner of this window, to add your first customer",
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
                            customerProvider.allCustomers.sort((a, b) => a.name
                                .toLowerCase()
                                .compareTo(b.name.toLowerCase())); //

                            return GeneralListTile.fromCustomers(
                              customer: appState.searchText.isEmpty
                                  ? customerProvider.allCustomers[index]
                                  : customerProvider.allCustomers
                                      .where((p) => p.name
                                          .toLowerCase()
                                          .contains(appState.searchText))
                                      .elementAt(index),
                              appState: appState,
                              provider: customerProvider,
                            );
                          },
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.grey[300],
                              ),
                          itemCount: appState.searchText.isEmpty
                              ? customerProvider.allCustomers.length
                              : customerProvider.allCustomers
                                  .where((p) => p.name
                                      .toLowerCase()
                                      .contains(appState.searchText))
                                  .length),
            ),
            SizedBox(height: sp.getHeight(30, screenHeight, screenWidth)),
            SizedBox(
              child: Row(
                children: [
                  if (sp.isDesktop(screenWidth)) Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Customer Count: ${customerProvider.allCustomers.length}",
                      style: textTheme
                          .textTheme(screenWidth)
                          .bodySmall!
                          .copyWith(color: Colors.black),
                    ),
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
