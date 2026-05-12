import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myanmar_meter_bill/config/app_config.dart';
import 'package:myanmar_meter_bill/main.dart';

void main() {
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
    "useMaterial3": true
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
    "input_error": "Enter valid units.",
    "units_label": "Units (kWh)",
    "units_hint": "e.g. 100",
    "calculate_button": "Calculate",
    "result_heading": "Estimated",
    "breakdown_heading": "Breakdown",
    "footnote": "Test config."
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
