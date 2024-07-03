import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';

class AppTextTheme {
  final SizeAndSpacing sp = SizeAndSpacing();

  TextTheme textTheme(double screenWidth) => TextTheme(
        displayLarge: TextStyle(
          fontSize: sp.getFontSize(32.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.25, // equivalent to line height of 40.0
        ),
        displayMedium: TextStyle(
          fontSize: sp.getFontSize(28.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.29, // equivalent to line height of 36.0
        ),
        displaySmall: TextStyle(
          fontSize: sp.getFontSize(24.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.33, // equivalent to line height of 32.0
        ),
        headlineLarge: TextStyle(
          fontSize: sp.getFontSize(20.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.4, // equivalent to line height of 28.0
        ),
        headlineMedium: TextStyle(
          fontSize: sp.getFontSize(18.0, screenWidth),
          fontWeight: FontWeight.w600,
          height: 1.44, // equivalent to line height of 26.0
        ),
        headlineSmall: TextStyle(
          fontSize: sp.getFontSize(16.0, screenWidth),
          fontWeight: FontWeight.w600,
          height: 1.5, // equivalent to line height of 24.0
        ),
        titleLarge: TextStyle(
          fontSize: sp.getFontSize(16.0, screenWidth),
          fontWeight: FontWeight.w500,
          height: 1.5, // equivalent to line height of 24.0
        ),
        titleMedium: TextStyle(
          fontSize: sp.getFontSize(14.0, screenWidth),
          fontWeight: FontWeight.w500,
          height: 1.57, // equivalent to line height of 22.0
        ),
        titleSmall: TextStyle(
          fontSize: sp.getFontSize(12.0, screenWidth),
          fontWeight: FontWeight.w500,
          height: 1.33, // equivalent to line height of 16.0
        ),
        bodyLarge: TextStyle(
          fontSize: sp.getFontSize(16.0, screenWidth),
          fontWeight: FontWeight.normal,
          height: 1.5, // equivalent to line height of 24.0
        ),
        bodyMedium: TextStyle(
          fontSize: sp.getFontSize(14.0, screenWidth),
          fontWeight: FontWeight.normal,
          height: 1.57, // equivalent to line height of 22.0
        ),
        bodySmall: TextStyle(
          fontSize: sp.getFontSize(12.0, screenWidth),
          fontWeight: FontWeight.normal,
          height: 1.33, // equivalent to line height of 16.0
        ),
        labelLarge: TextStyle(
          fontSize: sp.getFontSize(14.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.14, // equivalent to line height of 16.0
        ),
        labelMedium: TextStyle(
          fontSize: sp.getFontSize(12.0, screenWidth),
          fontWeight: FontWeight.bold,
          height: 1.33, // equivalent to line height of 16.0
        ),
        labelSmall: TextStyle(
          fontSize: sp.getFontSize(10.0, screenWidth),
          fontWeight: FontWeight.normal,
          height: 1.2, // equivalent to line height of 12.0
        ),
      );
}
