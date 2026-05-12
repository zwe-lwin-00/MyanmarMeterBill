import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/app_config_scope.dart';
import 'about_developer_tab.dart';
import 'bill_calculator_tab.dart';
import 'device_guide_tab.dart';
import 'theme_sheet.dart';

/// Three-tab shell: calculator, device power guide, about developer.
class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final config = AppConfigScope.of(context);
    final layout = config.layout;

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle(config)),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: config.optionalString(
              'theme_picker_tooltip',
              'Theme appearance',
            ),
            icon: Icon(
              switch (widget.themeMode) {
                ThemeMode.dark => Icons.dark_mode_outlined,
                ThemeMode.light => Icons.light_mode_outlined,
                ThemeMode.system => Icons.brightness_auto_outlined,
              },
            ),
            onPressed: () => showAppThemeSheet(
              context,
              current: widget.themeMode,
              onChanged: widget.onThemeModeChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          sizing: StackFit.expand,
          children: [
            BillCalculatorTab(layoutPadding: layout.pagePadding),
            DeviceGuideTab(layoutPadding: layout.pagePadding),
            AboutDeveloperTab(layoutPadding: layout.pagePadding),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: config.string('nav_tab_calculate'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.electric_bolt_outlined),
            selectedIcon: const Icon(Icons.electric_bolt),
            label: config.string('nav_tab_devices'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: config.string('nav_tab_about'),
          ),
        ],
      ),
    );
  }

  String _appBarTitle(AppConfig config) {
    return switch (_index) {
      0 => config.app.navigatorTitle,
      1 => config.deviceGuide.pageTitle,
      2 => config.aboutDeveloper.pageTitle,
      _ => config.app.navigatorTitle,
    };
  }
}
