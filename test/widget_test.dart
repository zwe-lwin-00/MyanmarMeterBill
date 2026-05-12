import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myanmar_meter_bill/config/app_config.dart';
import 'package:myanmar_meter_bill/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('calculate button runs tiered bill from config', (tester) async {
    final config = AppConfig.parseJsonString(_minimalTestConfigJson);
    await tester.pumpWidget(MyanmarMeterBillApp(config: config));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '100');
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Ks'), findsWidgets);
  });
}

/// English-only minimal config for stable widget tests (same JSON shape as production).
const String _minimalTestConfigJson = r'''
{
  "schemaVersion": 1,
  "app": {
    "materialTitle": "Test Bill",
    "navigatorTitle": "Test Electric Bill",
    "themeSeedColor": "#1976D2",
    "useMaterial3": true,
    "themeMode": "light"
  },
  "layout": {
    "pagePadding": 20,
    "sectionGapLarge": 16,
    "sectionGapMedium": 8,
    "sectionGapSmall": 8,
    "afterInputGap": 20,
    "resultTopGap": 28,
    "footnoteTopGap": 16,
    "buttonVerticalPadding": 14,
    "breakdownRowVerticalPadding": 6,
    "dividerHeight": 28
  },
  "formatting": {
    "currencyDisplayPrefix": "Ks ",
    "integerNumberPattern": "#,##0",
    "breakdownLineTemplate": "{{units}} kWh @ {{rate}} {{currencyPrefix}}",
    "totalUnitsTemplate": "Total {{units}} kWh",
    "totalAmountTemplate": "{{currencyPrefix}}{{amount}}"
  },
  "strings": {
    "page_intro": "Pick meter and enter kWh.",
    "meter_section_label": "Meter type",
    "input_error": "Enter valid units.",
    "input_error_zero": "Enter usage greater than 0 kWh.",
    "units_label": "Units (kWh)",
    "units_hint": "e.g. 100",
    "units_helper": "Use the kWh for this billing period from your statement.",
    "calculate_button": "Calculate",
    "clear_button": "Clear",
    "result_empty_hint": "Enter units and tap Calculate to see an estimate.",
    "estimate_chip": "Estimate only",
    "tier_incomplete_warning": "{{kwh}} kWh exceed configured tariff tiers.",
    "result_heading": "Estimated",
    "breakdown_heading": "Breakdown",
    "footnote": "Test config.",
    "theme_picker_title": "Appearance",
    "theme_picker_tooltip": "Theme",
    "theme_option_system": "System default",
    "theme_option_light": "Light",
    "theme_option_dark": "Dark"
  },
  "meterOptions": [
    {
      "id": "home",
      "segmentLabel": "Home",
      "detailLabel": "Residential",
      "tariffScheduleId": "flat_test"
    },
    {
      "id": "biz",
      "segmentLabel": "Business",
      "detailLabel": "Commercial",
      "tariffScheduleId": "flat_test"
    }
  ],
  "tariffSchedules": {
    "flat_test": [
      { "capacityKwh": 1000000, "kyatsPerKwh": 10 }
    ]
  }
}
''';
