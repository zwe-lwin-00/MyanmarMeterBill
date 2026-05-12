import 'package:flutter_test/flutter_test.dart';

import 'package:myanmar_meter_bill/config/app_config_loader.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled default_app_config.json loads and validates', () async {
    final config = await AppConfigLoader.loadDefault();
    expect(config.meterOptions, isNotEmpty);
    expect(config.tariffSchedules, isNotEmpty);
  });
}
