import 'package:flutter/material.dart';

import 'app_config.dart';

class AppConfigScope extends InheritedWidget {
  const AppConfigScope({
    required this.config,
    required super.child,
    super.key,
  });

  final AppConfig config;

  static AppConfig of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppConfigScope>();
    if (scope == null) {
      throw FlutterError(
        'AppConfigScope is missing. Wrap MaterialApp with AppConfigScope.',
      );
    }
    return scope.config;
  }

  @override
  bool updateShouldNotify(covariant AppConfigScope oldWidget) =>
      !identical(oldWidget.config, config);
}
