import 'package:flutter_test/flutter_test.dart';

import 'package:myanmar_meter_bill/config/required_config_keys.dart';

void main() {
  test('kRequiredUiStringKeys includes critical UI entries', () {
    expect(kRequiredUiStringKeys, isNotEmpty);
    expect(kRequiredUiStringKeys, containsAll(<String>[
      'footnote',
      'tier_incomplete_warning',
      'calculate_button',
    ]));
  });
}
