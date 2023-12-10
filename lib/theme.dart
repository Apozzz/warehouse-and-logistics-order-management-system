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
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black, // This is what you want to add!
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black, // Text color for ElevatedButton
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white, // Icon color for FAB
      backgroundColor: Colors.black, // Background color for FAB
    ),
  );
}
