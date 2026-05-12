import 'package:flutter/material.dart';

import '../config/app_config_scope.dart';

Future<void> showAppThemeSheet(
  BuildContext context, {
  required ThemeMode current,
  required ValueChanged<ThemeMode> onChanged,
}) async {
  final config = AppConfigScope.of(context);
  final scheme = Theme.of(context).colorScheme;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                config.optionalString(
                  'theme_picker_title',
                  'Appearance',
                ),
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: current,
              title: Row(
                children: [
                  Icon(Icons.brightness_auto_outlined, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      config.optionalString(
                        'theme_option_system',
                        'System default',
                      ),
                    ),
                  ),
                ],
              ),
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: current,
              title: Row(
                children: [
                  Icon(Icons.light_mode_outlined, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      config.optionalString(
                        'theme_option_light',
                        'Light',
                      ),
                    ),
                  ),
                ],
              ),
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                  Navigator.pop(ctx);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: current,
              title: Row(
                children: [
                  Icon(Icons.dark_mode_outlined, color: scheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      config.optionalString(
                        'theme_option_dark',
                        'Dark',
                      ),
                    ),
                  ),
                ],
              ),
              onChanged: (v) {
                if (v != null) {
                  onChanged(v);
                  Navigator.pop(ctx);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
