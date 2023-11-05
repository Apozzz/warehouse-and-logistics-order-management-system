import 'package:flutter/material.dart';

extension NavigatorExtensions on NavigatorState {
  Future<T?> pushReplacementNoTransition<T extends Object>(
    Widget screen,
  ) {
    return pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => screen,
        transitionDuration: const Duration(seconds: 0),
      ),
    );
  }
}
