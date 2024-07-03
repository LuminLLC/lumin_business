import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart'; 
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/general_platform/menu_controller.dart';
import 'package:lumin_business/widgets/release_notes_widget.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  final AppTextTheme textTheme = AppTextTheme();
  final SizeAndSpacing sp =SizeAndSpacing();
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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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

  Widget navigationIcon({required IconData icon, required String text, required double screenWidth}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        icon: Icon(
          icon,
          color: AppColor.black,
        ),
        label: Text(
          text,
          style: textTheme.textTheme(screenWidth).bodyMedium!
              .copyWith(color: AppColor.black),
        ),
        onPressed: () {},
      ),
    );
  }
}
