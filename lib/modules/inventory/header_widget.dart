import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/controllers/app_state.dart';
import 'package:lumin_business/controllers/menu_controller.dart';
import 'package:lumin_business/widgets/release_notes_widget.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String _getHeaderTitle(int index) {
    if (index == 0) {
      return "Dashboard";
    } else if (index == 1) {
      return "Accounts";
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
    return Consumer<AppState>(builder: (context, appState, _) {
      return Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              _getHeaderTitle(appState.index),
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: ((context) => ReleaseNotesWidget()));
              },
              icon: Icon(Icons.campaign),
              color: Colors.grey,
            ),
            if (!AppResponsive.isMobile(context)) ...{
              Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  navigationIcon(
                      icon: Icons.download,
                      text: "Download Inventory Snapshot"),
                ],
              )
            }
          ],
        ),
      );
    });
  }

  Widget navigationIcon({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton.icon(
        icon: Icon(
          icon,
          color: AppColor.black,
        ),
        label: Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {},
      ),
    );
  }
}
