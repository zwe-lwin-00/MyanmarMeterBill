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
  });
}

const String _sample = r'''
{
  "schemaVersion": 1,
  "app": {
    "materialTitle": "T",
    "navigatorTitle": "T",
    "themeSeedColor": "#000000",
    "useMaterial3": true
  },
  "layout": {},
  "formatting": {},
  "strings": { "page_intro": "x" },
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
