// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

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
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      label: Text(
        text,
        style: TextStyle(color: textColor ?? Colors.black),
      ),
      icon: Icon(
        icon,
        color: iconColor ?? Colors.black,
      ),
    );
  }
}
