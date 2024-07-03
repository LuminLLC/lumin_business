// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';

class LuminTextIconButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function() onPressed;
  Color? iconColor;
  Color? textColor;
  LuminTextIconButton(
      {Key? key,
      required this.text,
      this.iconColor,
      this.textColor,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10
        )),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColor.bgSideMenu),
      ),
      label: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      icon: Icon(
        icon,
        color: iconColor ?? Colors.white,
      ),
    );
  }
}
