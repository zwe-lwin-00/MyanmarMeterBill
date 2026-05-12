import 'package:flutter/material.dart';

import '../config/app_config_scope.dart';

class DeviceGuideTab extends StatelessWidget {
  const DeviceGuideTab({super.key, required this.layoutPadding});

  final double layoutPadding;

  @override
  Widget build(BuildContext context) {
    final config = AppConfigScope.of(context);
    final g = config.deviceGuide;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scrollbar(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(layoutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              g.intro,
              style: textTheme.bodyLarge?.copyWith(height: 1.45),
            ),
            const SizedBox(height: 20),
            ...g.items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  elevation: 0,
                  color: scheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: scheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (item.typicalWatts != null)
                              Chip(
                                label: Text(
                                  '~ ${item.typicalWatts} W',
                                  style: textTheme.labelMedium,
                                ),
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                              ),
                          ],
                        ),
                        if (item.notes.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            item.notes,
                            style: textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Text(
              config.optionalString(
                'devices_guide_disclaimer',
                'Figures are approximate; actual use depends on model, age, and settings.',
              ),
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
