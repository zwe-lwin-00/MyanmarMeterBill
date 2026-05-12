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
    this.uncapturedKwh = 0,
  });

  final int totalUnits;
  final int totalKyats;
  final List<TierBreakdown> breakdown;

  /// kWh not covered by [tiers] (tiers exhausted before all units were priced).
  final int uncapturedKwh;
}

/// Applies Myanmar-style **incremental** block tariffs: each tier’s rate applies only
/// to units filling that tier in order.
class ElectricBillCalculator {
  const ElectricBillCalculator();

  BillResult calculate(int unitsKwh, List<TariffTier> tiers) {
    if (unitsKwh <= 0) {
      return BillResult(
        totalUnits: unitsKwh,
        totalKyats: 0,
        breakdown: [],
        uncapturedKwh: 0,
      );
    }
    if (tiers.isEmpty) {
      throw ArgumentError.value(tiers, 'tiers', 'must not be empty');
    }
    for (final t in tiers) {
      if (t.capacityKwh <= 0) {
        throw ArgumentError.value(
          t.capacityKwh,
          'tier.capacityKwh',
          'must be positive',
        );
      }
      if (t.kyatsPerKwh < 0) {
        throw ArgumentError.value(
          t.kyatsPerKwh,
          'tier.kyatsPerKwh',
          'must be non-negative',
        );
      }
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

    return BillResult(
      totalUnits: unitsKwh,
      totalKyats: total,
      breakdown: breakdown,
      uncapturedKwh: remaining,
    );
  }
}
