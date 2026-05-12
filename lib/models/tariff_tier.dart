/// One pricing step: up to [capacityKwh] units at this step are charged at [kyatsPerKwh].
/// The last tier typically uses a very large capacity so all remaining units use that rate.
class TariffTier {
  const TariffTier({
    required this.capacityKwh,
    required this.kyatsPerKwh,
  });

  /// Max kWh billed at this rate in order (after previous tiers). Use a large value for “open” last tier.
  final int capacityKwh;
  final int kyatsPerKwh;
}
