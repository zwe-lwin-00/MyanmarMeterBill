import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:myanmar_meter_bill/config/app_config.dart';

void main() {
  test('AppConfig.fromJson parses tiers and meter schedule links', () {
    final json = jsonDecode(_sample) as Map<String, dynamic>;
    final c = AppConfig.fromJson(json);
    expect(c.meterOptions.first.tariffScheduleId, 'residential');
    expect(c.tiersForMeterId('home').first.kyatsPerKwh, 50);
    final roundTrip = AppConfig.fromJson(
      jsonDecode(c.encodeJson()) as Map<String, dynamic>,
    );
    expect(roundTrip.tariffSchedules['residential']!.length, 2);
    expect(roundTrip.deviceGuide.items.first.title, 'Lamp');
    expect(roundTrip.aboutDeveloper.developerName, 'Dev');
  });

  test('rejects invalid integerNumberPattern', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['formatting'] = {'integerNumberPattern': '%%%INVALID%%%'};
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects duplicate meter ids', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['meterOptions'] = [
      {
        'id': 'home',
        'segmentLabel': 'A',
        'detailLabel': 'A',
        'tariffScheduleId': 'residential',
      },
      {
        'id': 'home',
        'segmentLabel': 'B',
        'detailLabel': 'B',
        'tariffScheduleId': 'residential',
      },
    ];
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects non-positive capacityKwh', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['tariffSchedules'] = {
      'residential': [
        {'capacityKwh': 0, 'kyatsPerKwh': 50},
      ],
    };
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('accepts schemaVersion as JSON number (e.g. 1.0)', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['schemaVersion'] = 1.0;
    final c = AppConfig.fromJson(j);
    expect(c.schemaVersion, 1);
  });

  test('rejects strings missing a required key', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    final s = Map<String, dynamic>.from(
      (j['strings'] as Map).cast<String, dynamic>(),
    )..remove('footnote');
    j['strings'] = s;
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects totalUnitsTemplate without units placeholder', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['formatting'] = {
      'integerNumberPattern': '#,##0',
      'breakdownLineTemplate':
          '{{units}} kWh × {{rate}} {{currencyPrefix}}',
      'totalUnitsTemplate': 'no placeholder here',
      'totalAmountTemplate': '{{currencyPrefix}}{{amount}}',
    };
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects negative layout padding', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['layout'] = {'pagePadding': -1};
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects empty tariff schedule id key', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    j['tariffSchedules'] = {
      '': [
        {'capacityKwh': 10, 'kyatsPerKwh': 1},
      ],
    };
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });

  test('rejects empty app.materialTitle', () {
    final j = Map<String, dynamic>.from(
      jsonDecode(_sample) as Map<String, dynamic>,
    );
    (j['app'] as Map<String, dynamic>)['materialTitle'] = '   ';
    expect(() => AppConfig.fromJson(j), throwsA(isA<FormatException>()));
  });
}

const String _sample = r'''
{
  "schemaVersion": 1,
  "app": {
    "materialTitle": "T",
    "navigatorTitle": "T",
    "themeSeedColor": "#000000",
    "useMaterial3": true,
    "themeMode": "light"
  },
  "layout": {},
  "formatting": {},
  "strings": {
    "nav_tab_calculate": "Calc",
    "nav_tab_devices": "Devices",
    "nav_tab_about": "About",
    "page_intro": "x",
    "meter_section_label": "m",
    "input_error": "e",
    "input_error_zero": "z",
    "units_label": "u",
    "units_hint": "h",
    "units_helper": "p",
    "calculate_button": "c",
    "clear_button": "l",
    "result_empty_hint": "r",
    "estimate_chip": "i",
    "tier_incomplete_warning": "t {{kwh}}",
    "result_heading": "R",
    "breakdown_heading": "B",
    "footnote": "f",
    "maintenance_fee_checkbox": "Maint incl.",
    "maintenance_fee_breakdown": "Maintenance"
  },
  "deviceGuide": {
    "pageTitle": "Devices",
    "intro": "Intro text for device guide.",
    "items": [
      { "title": "Lamp", "typicalWatts": 10, "notes": "LED" }
    ]
  },
  "aboutDeveloper": {
    "pageTitle": "About",
    "developerName": "Dev",
    "paragraphs": ["Hello."]
  },
  "meterOptions": [
    {
      "id": "home",
      "segmentLabel": "H",
      "detailLabel": "H",
      "tariffScheduleId": "residential"
    }
  ],
  "tariffSchedules": {
    "residential": [
      { "capacityKwh": 10, "kyatsPerKwh": 50 },
      { "capacityKwh": 1000000, "kyatsPerKwh": 100 }
    ]
  }
}
''';
