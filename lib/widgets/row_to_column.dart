import 'package:flutter/material.dart';

class RowToColumn extends StatelessWidget {
  final List<Widget> children;
  final bool isDesktop;
  CrossAxisAlignment? crossAxisAlignment;
  MainAxisAlignment? mainAxisAlignment;

  RowToColumn(
      {Key? key,
      required this.children,
      required this.isDesktop,
      this.crossAxisAlignment,
      this.mainAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: children,
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly, // You can customize this
          );
        } else {
          return Column(
            children: children,
            mainAxisAlignment:
                MainAxisAlignment.center, // You can customize this
          );
        }
      },
    );
  }
}
