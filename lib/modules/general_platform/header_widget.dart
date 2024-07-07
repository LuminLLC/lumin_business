import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  final List<Widget> actions;
  TextEditingController? controller;
  HeaderWidget({Key? key, required this.actions, this.controller})
      : super(key: key);
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final AppTextTheme textTheme = AppTextTheme();
  final SizeAndSpacing sp = SizeAndSpacing();
  String _getHeaderTitle(int index) {
    if (index == 0) {
      return "Dashboard";
    } else if (index == 1) {
      return "Accounting";
    } else if (index == 2) {
      return "Inventory";
    } else if (index == 3) {
      return "Customers";
    } else if (index == 4) {
      return "Suppliers";
    } else {
      return "Settings";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<AppState>(builder: (context, appState, _) {
      return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(_getHeaderTitle(appState.index),
                style: textTheme.textTheme(screenWidth).displayMedium!.copyWith(
                      color: AppColor.black,
                    )),
            if (!sp.isMobile(screenWidth)) ...{
              Spacer(),
              widget.controller != null
                  ? SizedBox(
                      width: sp.getWidth(350, screenWidth),
                      height: 50,
                      child: SearchBar(
                        textStyle: WidgetStatePropertyAll(AppTextTheme()
                            .textTheme(screenWidth)
                            .bodyLarge!
                            .copyWith(color: AppColor.bgSideMenu)),
                        leading: Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(
                            Icons.search,
                            color: AppColor.bgSideMenu,
                          ),
                        ),
                        trailing: widget.controller!.text.isNotEmpty
                            ? [
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.close))
                              ]
                            : null,
                        hintText: "Search",
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.grey[100]),
                        elevation: WidgetStatePropertyAll(0),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  navigationIcon(
                      icon: Icons.add,
                      screenWidth: screenWidth,
                      text: "Download Inventory Snapshot"),
                  navigationIcon(
                      icon: Icons.download,
                      screenWidth: screenWidth,
                      text: "Download Inventory Snapshot"),
                ],
              )
            }
          ],
        ),
      );
    });
  }

  Widget navigationIcon(
      {required IconData icon,
      required String text,
      required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        icon: Icon(
          icon,
          color: AppColor.black,
        ),
        onPressed: () {},
      ),
    );
  }
}
