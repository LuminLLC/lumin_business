import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';

class ReleaseNotesWidget extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
  ReleaseNotesWidget({Key? key}) : super(key: key);

  List<String> features = [
    "Invetory insights",
    "Complete inventory list",
    "Search prodcuts by name",
    "Order creation and fulfilment",
    "Automatic invetory adjustment",
    "Daily sales total for storefront view"
        "Daily Order history for storefront view",
    "Access Control for admin and staff",
  ];

  List<String> knownIssues = [
    "Desktop-only access",
    "Online-only access",
    "Unoptimized fulfillment"
  ];
  List<String> comingUp = [
    "Product add - admin feature",
    "Product delete - admin feature",
    "Product quantity override - admin feature",
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Lumin Business",
              style: TextStyle(fontSize: sp.getFontSize(24, screenWidth))),
          SizedBox(
            width: sp.getWidth(500, screenWidth),
          ),
          Text(
            "Release Notes: Private beta 1.0.0",
            style: TextStyle(fontSize: sp.getFontSize(14, screenWidth)),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Features",
                style: TextStyle(fontSize: sp.getFontSize(20, screenWidth))),
            Divider(),
            for (String s in features)
              ListTile(
                leading: Text("${features.indexOf(s) + 1}"),
                title: Text(s),
              ),
            SizedBox(
              height: sp.getHeight(10, screenHeight, screenWidth),
            ),
            Text("Upcomming Features",
                style: TextStyle(fontSize: sp.getFontSize(20, screenWidth))),
            Divider(),
            for (String s in comingUp)
              ListTile(
                leading: Text("${comingUp.indexOf(s) + 1}"),
                title: Text(s),
              ),
            SizedBox(
              height: sp.getHeight(10, screenHeight, screenWidth),
            ),
            Text("Known Issues",
                style: TextStyle(fontSize: sp.getFontSize(20, screenWidth))),
            Divider(),
            for (String s in knownIssues)
              ListTile(
                leading: Text("${knownIssues.indexOf(s) + 1}"),
                title: Text(s),
              ),
          ],
        ),
      ),
    );
  }
}
