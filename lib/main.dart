import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'config/app_config_loader.dart';
import 'config/app_config_scope.dart';
import 'theme/user_theme_mode_storage.dart';
import 'ui/main_shell.dart';

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

class MyanmarMeterBillApp extends StatefulWidget {
  const MyanmarMeterBillApp({super.key, required this.config});

  final AppConfig config;

  @override
  State<MyanmarMeterBillApp> createState() => _MyanmarMeterBillAppState();
}

class _MyanmarMeterBillAppState extends State<MyanmarMeterBillApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.config.app.materialThemeMode;
    _restoreUserTheme();
  }

  Future<void> _restoreUserTheme() async {
    final saved = await UserThemeModeStorage.load();
    if (!mounted) return;
    if (saved != null) {
      setState(() => _themeMode = saved);
    }
  }

  Future<void> _onUserThemeModeChanged(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    await UserThemeModeStorage.save(mode);
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.config.app;
    return AppConfigScope(
      config: widget.config,
      child: MaterialApp(
        title: app.materialTitle,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 0.88,
            maxScaleFactor: kIsWeb ? 1.2 : 1.34,
            child: child ?? const SizedBox.shrink(),
          );
        },
        themeMode: _themeMode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: app.themeSeedColor,
            brightness: Brightness.light,
          ),
          useMaterial3: app.useMaterial3,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: app.themeSeedColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: app.useMaterial3,
        ),
        home: MainShell(
          themeMode: _themeMode,
          onThemeModeChanged: _onUserThemeModeChanged,
        ),
      ),
    );
  }
}
