import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final baseTheme = ThemeData.light(); // Base light theme

  return baseTheme.copyWith(
    primaryColor: Colors.white,
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.black,
    ),
    textTheme: baseTheme.textTheme.apply(bodyColor: Colors.black),
    colorScheme: baseTheme.colorScheme.copyWith(
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.black,
      onSecondary: Colors.white,
    ),
  );
}
