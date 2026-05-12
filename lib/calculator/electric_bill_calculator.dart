import '../models/tariff_tier.dart';

class TierBreakdown {
  const TierBreakdown({
    required this.kwhInTier,
    required this.kyatsPerKwh,
    required this.subtotalKyats,
  });

  final int kwhInTier;
  final int kyatsPerKwh;
  final int subtotalKyats;
}

class BillResult {
  const BillResult({
    required this.totalUnits,
    required this.totalKyats,
    required this.breakdown,
  });

  final int totalUnits;
  final int totalKyats;
  final List<TierBreakdown> breakdown;
}

/// Applies Myanmar-style **incremental** block tariffs: each tier’s rate applies only
/// to units filling that tier in order.
class ElectricBillCalculator {
  const ElectricBillCalculator();

  BillResult calculate(int unitsKwh, List<TariffTier> tiers) {
    if (unitsKwh <= 0) {
      return BillResult(totalUnits: unitsKwh, totalKyats: 0, breakdown: []);
    }

    var remaining = unitsKwh;
    final breakdown = <TierBreakdown>[];
    var total = 0;

    for (final tier in tiers) {
      if (remaining <= 0) break;
      final take = remaining < tier.capacityKwh ? remaining : tier.capacityKwh;
      final subtotal = take * tier.kyatsPerKwh;
      breakdown.add(
        TierBreakdown(
          kwhInTier: take,
          kyatsPerKwh: tier.kyatsPerKwh,
          subtotalKyats: subtotal,
        ),
      );
      total += subtotal;
      remaining -= take;
    }

    // If tiers don’t cover huge consumption, remaining units would need another tier.
    // Last tier uses a large capacity; any overflow is ignored until tiers are updated.
    return BillResult(
      totalUnits: unitsKwh,
      totalKyats: total,
      breakdown: breakdown,
    );
  }
}
