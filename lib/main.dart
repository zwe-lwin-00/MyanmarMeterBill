import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'config/app_config_loader.dart';
import 'config/app_config_scope.dart';
import 'ui/bill_calculator_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? loadError;
  AppConfig? config;
  try {
    config = await AppConfigLoader.loadDefault();
  } catch (e, st) {
    loadError = e;
    FlutterError.dumpErrorToConsole(
      FlutterErrorDetails(exception: e, stack: st),
    );
  }
  runApp(_BootstrapApp(config: config, loadError: loadError));
}

/// Root widget: shows a clear error if bundled JSON fails to load.
class _BootstrapApp extends StatelessWidget {
  const _BootstrapApp({this.config, this.loadError});

  final AppConfig? config;
  final Object? loadError;

  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SelectableText(
                'Could not load ${AppConfigLoader.defaultAssetPath}\n\n$loadError',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    return MyanmarMeterBillApp(config: config!);
  }
}

class MyanmarMeterBillApp extends StatelessWidget {
  const MyanmarMeterBillApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    final app = config.app;
    return AppConfigScope(
      config: config,
      child: MaterialApp(
        title: app.materialTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: app.themeSeedColor,
            brightness: Brightness.light,
          ),
          useMaterial3: app.useMaterial3,
        ),
        home: const BillCalculatorPage(),
      ),
    );
  }
}
