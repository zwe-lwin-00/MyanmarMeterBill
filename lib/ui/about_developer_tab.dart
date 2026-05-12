import 'package:flutter/material.dart';

import '../config/app_config_scope.dart';
import 'responsive_layout.dart';

class AboutDeveloperTab extends StatelessWidget {
  const AboutDeveloperTab({super.key, required this.layoutPadding});

  final double layoutPadding;

  @override
  Widget build(BuildContext context) {
    final config = AppConfigScope.of(context);
    final a = config.aboutDeveloper;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scrollbar(
      thumbVisibility: scrollbarThumbInteractive(),
      child: SingleChildScrollView(
        padding: responsiveScrollPadding(layoutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              a.developerName,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (a.role != null) ...[
              const SizedBox(height: 4),
              Text(
                a.role!,
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 20),
            for (final p in a.paragraphs)
              if (p.trim().isNotEmpty) ...[
                Text(
                  p.trim(),
                  style: textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 16),
              ],
            if (a.linkUrl != null && a.linkUrl!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                a.linkLabel ?? 'Link',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              SelectionArea(
                child: SelectableText(
                  a.linkUrl!.trim(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
