import 'package:flutter_test/flutter_test.dart';

import 'package:myanmar_meter_bill/calculator/electric_bill_calculator.dart';
import 'package:myanmar_meter_bill/models/tariff_tier.dart';

void main() {
  const calc = ElectricBillCalculator();

  test('tiered totals match incremental blocks', () {
    final tiers = [
      const TariffTier(capacityKwh: 10, kyatsPerKwh: 50),
      const TariffTier(capacityKwh: 90, kyatsPerKwh: 100),
    ];
    final r = calc.calculate(100, tiers);
    expect(r.totalKyats, 10 * 50 + 90 * 100);
    expect(r.uncapturedKwh, 0);
  });

  test('uncaptured kWh when tiers end before usage is priced', () {
    final tiers = [
      const TariffTier(capacityKwh: 5, kyatsPerKwh: 10),
    ];
    final r = calc.calculate(100, tiers);
    expect(r.uncapturedKwh, 95);
  test('throws on empty tiers when usage positive', () {
    expect(
      () => calc.calculate(10, const <TariffTier>[]),
      throwsA(isA<ArgumentError>()),
    );
  });
}
