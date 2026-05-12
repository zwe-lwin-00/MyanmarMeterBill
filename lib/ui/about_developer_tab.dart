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
            if (a.phone != null && a.phone!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                a.phoneLabel ?? 'Phone',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              SelectionArea(
                child: SelectableText(
                  a.phone!.trim(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
            if (a.email != null && a.email!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                a.emailLabel ?? 'Email',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              SelectionArea(
                child: SelectableText(
                  a.email!.trim(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
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
            if (a.portfolioUrl != null &&
                a.portfolioUrl!.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                a.portfolioLabel ?? 'Portfolio',
                style: textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              SelectionArea(
                child: SelectableText(
                  a.portfolioUrl!.trim(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
            if (a.feedbackMessage != null &&
                a.feedbackMessage!.trim().isNotEmpty) ...[
              const SizedBox(height: 24),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        a.feedbackTitle ?? 'Feedback',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        a.feedbackMessage!.trim(),
                        style: textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
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
