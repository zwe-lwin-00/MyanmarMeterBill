import 'package:flutter/services.dart';

import 'app_config.dart';

/// Loads [AppConfig] from a Flutter asset (shareable JSON file).
class AppConfigLoader {
  AppConfigLoader._();

  /// Default bundled asset. Override at compile time, e.g.:
  /// `flutter run --dart-define=APP_CONFIG_ASSET=assets/config/custom.json`
  static const String defaultAssetPath = String.fromEnvironment(
    'APP_CONFIG_ASSET',
    defaultValue: 'assets/config/default_app_config.json',
  );

  static Future<AppConfig> loadDefault({AssetBundle? bundle}) =>
      loadFromAsset(defaultAssetPath, bundle: bundle);

  static Future<AppConfig> loadFromAsset(
    String assetPath, {
    AssetBundle? bundle,
  }) async {
    final b = bundle ?? rootBundle;
    final raw = await b.loadString(assetPath);
    return AppConfig.parseJsonString(raw);
  }
}
