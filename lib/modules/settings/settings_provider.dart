import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  int index = 0;
  final List<String> settingsMenu = [
    "Business Information",
    "Users",
    "Security",
    "Notifications",
  ];

  void setIndex(int i) {
    if (index != i) {
      index = i;
      notifyListeners();
    }
  }
}
