import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/header_widget.dart';
import 'package:lumin_business/modules/settings/settings_provider.dart';
import 'package:lumin_business/widgets/general_list_tile.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AppTextTheme textTheme = AppTextTheme();
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AppState>(builder: (context, appState, _) {
      List<String> itemLabels = [
        "Business Name",
        "Logo",
        "Admin Email",
        "Business Address",
        "Primary Contact Number",
        "Business Type",
        "Business Description",
        "Sub Accounts"
      ];
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
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("How may we help you?"),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: sp.getWidth(600, screenWidth),
                                    ),
                                    DropdownButtonFormField<dynamic>(
                                      hint: Text(
                                        "What do you need help with?",
                                        style: TextStyle(
                                          color: Colors.grey[
                                              300], // Adjust this color to match your style
                                        ),
                                      ),
                                      value: null,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.help,
                                          color: Colors.white,
                                          size: sp.getWidth(20, screenWidth),
                                        ),
                                        // errorText: locationError,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[
                                              300], // Adjust this color to match your style
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              5), // Rounded corners
                                          borderSide: BorderSide(
                                            color: Colors
                                                .grey[50]!, // Border color
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Rounded corners
                                          borderSide: BorderSide(
                                            color: Colors
                                                .blue, // Border color when focused
                                            width: 2.0,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.only(
                                          left:
                                              12.0, // Horizontal padding inside the dropdown
                                        ),
                                      ),
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Icon(
                                          Icons
                                              .arrow_drop_down, // Icon for the dropdown
                                          color: Colors.grey[
                                              700], // Adjust this color to match your style
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: Colors
                                            .white, // Text color inside the dropdown
                                        fontSize:
                                            16.0, // Text size inside the dropdown
                                      ),
                                      onChanged: (value) {
                                        // if (locationError != null) {
                                        //   setState(() {
                                        //     locationError = null;
                                        //   });
                                        //   widget.orderProvider
                                        //       .setOrderPos(value);
                                        // }
                                      },
                                      items: [
                                        "General Inquiry",
                                        "Technical Support",
                                        "Feedback",
                                        "Report a Bug",
                                        "Feature Request"
                                      ].map<DropdownMenuItem<dynamic>>(
                                          (dynamic value) {
                                        return DropdownMenuItem<dynamic>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    TextField(
                                      maxLines: 5,
                                    )
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Send"),
                                ),
                              ],
                            );
                          });
                    },
                    icon: Icon(Icons.contact_support),
                    color: AppColor.black,
                  )
                ],
              ),
            Consumer<SettingsProvider>(builder: (context, settingsProvider, _) {
              return Container(
                height: sp.getHeight(90, screenHeight, screenWidth),
                width: sp.getWidth(1360, screenWidth),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: sp.getWidth(20, screenWidth),
                    ),
                    for (String s in settingsProvider.settingsMenu)
                      Padding(
                        padding: EdgeInsets.only(
                          right: sp.getWidth(59, screenWidth),
                        ),
                        child: InkWell(
                          onTap: () => settingsProvider.setIndex(
                              settingsProvider.settingsMenu.indexOf(s)),
                          child: menuItem(
                              screenHeight: screenHeight,
                              currentIndex: settingsProvider.index,
                              indexOfItem:
                                  settingsProvider.settingsMenu.indexOf(s),
                              screenWidth: screenWidth,
                              title: s),
                        ),
                      )
                  ],
                ),
              );
            }),
            // Expanded(
            //   child: appState.businessInfo == null
            //       ? Center(
            //           child: CircularProgressIndicator(),
            //         )
            //       : ListView.separated(
            //           shrinkWrap: true,
            //           padding: EdgeInsets.zero,
            //           itemBuilder: (context, index) {
            //             return GeneralListTile.fromSettings(
            //               businessInfo: appState.businessInfo,
            //               itemLabels: itemLabels,
            //               index: index,
            //               appState: appState,
            //             );
            //           },
            //           separatorBuilder: (context, index) => Divider(
            //                 color: Colors.grey[300],
            //               ),
            //           itemCount: appState.businessInfo!.toList().length),
            // ),
            // TextButton.icon(
            //     onPressed: () {},
            //     label: Text(
            //       "Delete Account",
            //       style: TextStyle(color: Colors.black),
            //     ),
            //     icon: Icon(
            //       Icons.delete,
            //       color: Colors.red,
            //     )),
          ],
        ),
      );
    });
  }

  Widget menuItem(
      {required double screenHeight,
      required double screenWidth,
      required int currentIndex,
      required int indexOfItem,
      required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: sp.getHeight(28, screenHeight, screenWidth),
        ),
        Text(
          title,
          style: GoogleFonts.dmSans(
              fontSize: sp.getFontSize(24, screenWidth),
              fontWeight: FontWeight.w200,
              color: const Color.fromRGBO(22, 37, 33, 1)),
        ),
        if (indexOfItem == currentIndex) const Spacer(),
        if (indexOfItem == currentIndex)
          Container(
            height: sp.getHeight(7, screenHeight, screenWidth),
            width: sp.getWidth(217, screenWidth),
            decoration: BoxDecoration(
              color: AppColor.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
      ],
    );
  }
}
