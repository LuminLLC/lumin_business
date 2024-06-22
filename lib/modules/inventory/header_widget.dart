import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_responsive.dart';
import 'package:lumin_business/controllers/menu_controller.dart';
import 'package:lumin_business/widgets/release_notes_widget.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Text(
            "Inventory",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
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
                    icon: Icons.download, text: "Download Inventory Snapshot"),
              ],
            )
          }
        ],
      ),
    );
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
