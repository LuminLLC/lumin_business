 

// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/size_and_spacing.dart';

class LuminTextIconButton extends StatelessWidget {
  final SizeAndSpacing sp = SizeAndSpacing();
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return TextButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
            vertical: sp.getHeight(10, screenHeight, screenWidth),
            horizontal: sp.getWidth(10, screenWidth))),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppColor.bgSideMenu),
      ),
      label: Text(text,
          style: AppTextTheme.textTheme.bodySmall!.copyWith(
            color: textColor ?? Colors.white,
          )),
      icon: Icon(
        icon,
        size: sp.getWidth(15, screenWidth),
        color: iconColor ?? Colors.white,
      ),
    );
  }
}
