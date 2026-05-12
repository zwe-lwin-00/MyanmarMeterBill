import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/extra_content.dart';
import '../models/tariff_tier.dart';
import 'required_config_keys.dart';
import 'string_template.dart';

class AppSection {
  const AppSection({
    required this.materialTitle,
    required this.navigatorTitle,
    required this.themeSeedColor,
    required this.useMaterial3,
    required this.themeMode,
  });

  final String materialTitle;
  final String navigatorTitle;
  final Color themeSeedColor;
  final bool useMaterial3;

  /// `light`, `dark`, or `system` (case-insensitive).
  final String themeMode;

  Map<String, Object?> toJson() => {
        'materialTitle': materialTitle,
        'navigatorTitle': navigatorTitle,
        'themeSeedColor': _colorToHex(themeSeedColor),
        'useMaterial3': useMaterial3,
        'themeMode': themeMode,
      };

  static AppSection fromJson(Map<String, dynamic> json) {
    final hex = json['themeSeedColor'] as String? ?? '#1E88E5';
    final materialTitle = (json['materialTitle'] as String? ?? '').trim();
    final navigatorTitle = (json['navigatorTitle'] as String? ?? '').trim();
    if (materialTitle.isEmpty) {
      throw const FormatException('app.materialTitle must not be empty');
    }
    if (navigatorTitle.isEmpty) {
      throw const FormatException('app.navigatorTitle must not be empty');
    }
    final mode = (json['themeMode'] as String? ?? 'system').toLowerCase();
    return AppSection(
      materialTitle: materialTitle,
      navigatorTitle: navigatorTitle,
      themeSeedColor: _parseHexColor(hex),
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      themeMode: mode == 'dark' || mode == 'light' || mode == 'system'
          ? mode
          : 'system',
    );
  }

  ThemeMode get materialThemeMode => switch (themeMode) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        _ => ThemeMode.system,
      };
}

class LayoutSection {
  const LayoutSection({
    required this.pagePadding,
    required this.sectionGapLarge,
    required this.sectionGapMedium,
    required this.sectionGapSmall,
    required this.afterInputGap,
    required this.resultTopGap,
    required this.footnoteTopGap,
    required this.buttonVerticalPadding,
    required this.breakdownRowVerticalPadding,
    required this.dividerHeight,
  });

  final double pagePadding;
  final double sectionGapLarge;
  final double sectionGapMedium;
  final double sectionGapSmall;
  final double afterInputGap;
  final double resultTopGap;
  final double footnoteTopGap;
  final double buttonVerticalPadding;
  final double breakdownRowVerticalPadding;
  final double dividerHeight;

  Map<String, Object?> toJson() => {
        'pagePadding': pagePadding,
        'sectionGapLarge': sectionGapLarge,
        'sectionGapMedium': sectionGapMedium,
        'sectionGapSmall': sectionGapSmall,
        'afterInputGap': afterInputGap,
        'resultTopGap': resultTopGap,
        'footnoteTopGap': footnoteTopGap,
        'buttonVerticalPadding': buttonVerticalPadding,
        'breakdownRowVerticalPadding': breakdownRowVerticalPadding,
        'dividerHeight': dividerHeight,
      };

  static LayoutSection fromJson(Map<String, dynamic>? json) {
    if (json == null) return LayoutSection.defaults();
    double d(String k, double def) =>
        (json[k] as num?)?.toDouble() ?? def;
    return LayoutSection(
      pagePadding: d('pagePadding', 20),
      sectionGapLarge: d('sectionGapLarge', 16),
      sectionGapMedium: d('sectionGapMedium', 8),
      sectionGapSmall: d('sectionGapSmall', 8),
      afterInputGap: d('afterInputGap', 20),
      resultTopGap: d('resultTopGap', 28),
      footnoteTopGap: d('footnoteTopGap', 16),
      buttonVerticalPadding: d('buttonVerticalPadding', 14),
      breakdownRowVerticalPadding: d('breakdownRowVerticalPadding', 6),
      dividerHeight: d('dividerHeight', 28),
    );
  }

  static LayoutSection defaults() => const LayoutSection(
        pagePadding: 20,
        sectionGapLarge: 16,
        sectionGapMedium: 8,
        sectionGapSmall: 8,
        afterInputGap: 20,
        resultTopGap: 28,
        footnoteTopGap: 16,
        buttonVerticalPadding: 14,
        breakdownRowVerticalPadding: 6,
        dividerHeight: 28,
      );
}

class FormattingSection {
  const FormattingSection({
    required this.currencyDisplayPrefix,
    required this.integerNumberPattern,
    required this.breakdownLineTemplate,
    required this.totalUnitsTemplate,
    required this.totalAmountTemplate,
  });

  final String currencyDisplayPrefix;
  final String integerNumberPattern;
  final String breakdownLineTemplate;
  final String totalUnitsTemplate;
  final String totalAmountTemplate;

  Map<String, Object?> toJson() => {
        'currencyDisplayPrefix': currencyDisplayPrefix,
        'integerNumberPattern': integerNumberPattern,
        'breakdownLineTemplate': breakdownLineTemplate,
        'totalUnitsTemplate': totalUnitsTemplate,
        'totalAmountTemplate': totalAmountTemplate,
      };

  static FormattingSection fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      final d = FormattingSection.defaults();
      _validateNumberPattern(d.integerNumberPattern);
      return d;
    }
    final pattern = json['integerNumberPattern'] as String? ?? '#,##0';
    _validateNumberPattern(pattern);
    return FormattingSection(
      currencyDisplayPrefix:
          json['currencyDisplayPrefix'] as String? ?? 'Ks ',
      integerNumberPattern: pattern,
      breakdownLineTemplate: json['breakdownLineTemplate'] as String? ??
          '{{units}} kWh × {{rate}} {{currencyPrefix}}',
      totalUnitsTemplate: json['totalUnitsTemplate'] as String? ??
          'Total {{units}} kWh',
      totalAmountTemplate: json['totalAmountTemplate'] as String? ??
          '{{currencyPrefix}}{{amount}}',
    );
  }

  static void _validateNumberPattern(String pattern) {
    try {
      NumberFormat(pattern).format(1234567);
    } catch (e) {
      throw FormatException(
        'Invalid integerNumberPattern "$pattern": $e',
      );
    }
  }

  static FormattingSection defaults() => const FormattingSection(
        currencyDisplayPrefix: 'Ks ',
        integerNumberPattern: '#,##0',
        breakdownLineTemplate:
            '{{units}} kWh × {{rate}} {{currencyPrefix}}',
        totalUnitsTemplate: 'Total {{units}} kWh',
        totalAmountTemplate: '{{currencyPrefix}}{{amount}}',
      );
}

class MeterOption {
  const MeterOption({
    required this.id,
    required this.segmentLabel,
    required this.detailLabel,
    required this.tariffScheduleId,
    this.maintenanceFeeKyats,
  });

  final String id;
  final String segmentLabel;
  final String detailLabel;
  final String tariffScheduleId;

  /// Optional fixed fee (e.g. residential ပြုပြင်ထိန်းသိမ်းခ), kyats.
  final int? maintenanceFeeKyats;

  Map<String, Object?> toJson() => {
        'id': id,
        'segmentLabel': segmentLabel,
        'detailLabel': detailLabel,
        'tariffScheduleId': tariffScheduleId,
        if (maintenanceFeeKyats != null) 'maintenanceFeeKyats': maintenanceFeeKyats,
      };

  static MeterOption fromJson(Map<String, dynamic> json) {
    final feeRaw = json['maintenanceFeeKyats'] as num?;
    final fee = feeRaw?.round();
    if (fee != null && fee < 0) {
      throw const FormatException(
        'meterOptions.maintenanceFeeKyats must be non-negative',
      );
    }
    return MeterOption(
      id: json['id'] as String? ?? 'default',
      segmentLabel: json['segmentLabel'] as String? ?? json['id'] as String,
      detailLabel: json['detailLabel'] as String? ??
          json['segmentLabel'] as String? ??
          '',
      tariffScheduleId:
          json['tariffScheduleId'] as String? ?? json['id'] as String,
      maintenanceFeeKyats: (fee == null || fee == 0) ? null : fee,
    );
  }
}

/// Full application configuration: shareable as JSON ([toJson] / [encodeJson]).
class AppConfig {
  const AppConfig({
    required this.schemaVersion,
    required this.app,
    required this.layout,
    required this.formatting,
    required this.strings,
    required this.deviceGuide,
    required this.aboutDeveloper,
    required this.meterOptions,
    required this.tariffSchedules,
  });

  final int schemaVersion;
  final AppSection app;
  final LayoutSection layout;
  final FormattingSection formatting;
  final Map<String, String> strings;
  final DeviceGuideContent deviceGuide;
  final AboutDeveloperContent aboutDeveloper;
  final List<MeterOption> meterOptions;
  final Map<String, List<TariffTier>> tariffSchedules;

  String string(String key) => strings[key] ?? key;

  /// Optional UI copy: uses [strings] when non-empty, else [fallback].
  /// Not validated by [kRequiredUiStringKeys] (e.g. theme picker labels).
  String optionalString(String key, String fallback) {
    final v = strings[key];
    if (v == null || v.trim().isEmpty) return fallback;
    return v;
  }

  /// Replaces `{{name}}` placeholders in a [strings] value.
  String fillString(String key, Map<String, String> vars) =>
      applyTemplate(string(key), vars);

  String formatTotalAmount(String formattedAmount) {
    return applyTemplate(formatting.totalAmountTemplate, {
      'currencyPrefix': formatting.currencyDisplayPrefix,
      'amount': formattedAmount,
    });
  }

  String formatTotalUnits(int units) {
    return applyTemplate(formatting.totalUnitsTemplate, {
      'units': '$units',
    });
  }

  String formatBreakdownLine({
    required int unitsInTier,
    required int kyatsPerKwh,
  }) {
    return applyTemplate(formatting.breakdownLineTemplate, {
      'units': '$unitsInTier',
      'rate': '$kyatsPerKwh',
      'currencyPrefix': formatting.currencyDisplayPrefix,
    });
  }

  List<TariffTier> tiersForMeterId(String meterId) {
    MeterOption? option;
    for (final o in meterOptions) {
      if (o.id == meterId) {
        option = o;
        break;
      }
    }
    if (option == null) {
      throw StateError('Unknown meter id: $meterId');
    }
    final tiers = tariffSchedules[option.tariffScheduleId];
    if (tiers == null || tiers.isEmpty) {
      throw StateError(
        'Missing or empty tariff schedule "${option.tariffScheduleId}"',
      );
    }
    return tiers;
  }

  Map<String, Object?> toJson() => {
        'schemaVersion': schemaVersion,
        'app': app.toJson(),
        'layout': layout.toJson(),
        'formatting': formatting.toJson(),
        'strings': strings,
        'deviceGuide': deviceGuide.toJson(),
        'aboutDeveloper': aboutDeveloper.toJson(),
        'meterOptions': meterOptions.map((e) => e.toJson()).toList(),
        'tariffSchedules': tariffSchedules.map(
          (k, v) => MapEntry(
            k,
            v
                .map(
                  (t) => {
                    'capacityKwh': t.capacityKwh,
                    'kyatsPerKwh': t.kyatsPerKwh,
                  },
                )
                .toList(),
          ),
        ),
      };

  String encodeJson() =>
      const JsonEncoder.withIndent('  ').convert(toJson());

  static AppConfig fromJson(Map<String, dynamic> json) {
    final version = _readSchemaVersion(json['schemaVersion']);
    if (version != 1) {
      throw FormatException('Unsupported schemaVersion: $version');
    }

    final appMap = json['app'] as Map<String, dynamic>?;
    if (appMap == null) {
      throw const FormatException('Missing "app" section');
    }

    final meters = (json['meterOptions'] as List<dynamic>?)
            ?.map((e) => MeterOption.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    if (meters.isEmpty) {
      throw const FormatException('meterOptions must not be empty');
    }

    final seenMeterIds = <String>{};
    for (final m in meters) {
      if (m.id.trim().isEmpty) {
        throw const FormatException('meterOptions id must not be empty');
      }
      if (!seenMeterIds.add(m.id)) {
        throw FormatException('Duplicate meter id: ${m.id}');
      }
      if (m.tariffScheduleId.trim().isEmpty) {
        throw FormatException(
          'meterOptions.tariffScheduleId must not be empty (meter id: ${m.id})',
        );
      }
    }

    final scheduleJson =
        json['tariffSchedules'] as Map<String, dynamic>? ?? {};
    final schedules = <String, List<TariffTier>>{};
    for (final e in scheduleJson.entries) {
      if (e.key.trim().isEmpty) {
        throw const FormatException(
          'tariffSchedules must not use an empty schedule id',
        );
      }
      final list = e.value as List<dynamic>?;
      if (list == null || list.isEmpty) {
        throw FormatException('Empty tariff schedule: ${e.key}');
      }
      schedules[e.key] = list.map((row) {
        final m = row as Map<String, dynamic>;
        final cap = m['capacityKwh'] as num?;
        final rate = m['kyatsPerKwh'] as num?;
        if (cap == null || rate == null) {
          throw FormatException('Invalid tier in schedule ${e.key}');
        }
        final capR = cap.round();
        final rateR = rate.round();
        if (capR <= 0) {
          throw FormatException(
            'capacityKwh must be positive in schedule ${e.key}',
          );
        }
        if (rateR < 0) {
          throw FormatException(
            'kyatsPerKwh must be non-negative in schedule ${e.key}',
          );
        }
        return TariffTier(
          capacityKwh: capR,
          kyatsPerKwh: rateR,
        );
      }).toList();
    }

    for (final m in meters) {
      if (!schedules.containsKey(m.tariffScheduleId)) {
        throw FormatException(
          'meterOptions references missing schedule "${m.tariffScheduleId}"',
        );
      }
    }

    final stringsMap = json['strings'] as Map<String, dynamic>? ?? {};
    final strings = stringsMap.map(
      (k, v) => MapEntry(k, v?.toString() ?? ''),
    );

    final layout = LayoutSection.fromJson(json['layout'] as Map<String, dynamic>?);
    final formatting = FormattingSection.fromJson(
      json['formatting'] as Map<String, dynamic>?,
    );
    final app = AppSection.fromJson(appMap);

    _validateLayout(layout);
    _validateFormattingTemplates(formatting);
    _validateUiStrings(strings);

    final deviceGuide = DeviceGuideContent.fromJson(json['deviceGuide']);
    _validateDeviceGuide(deviceGuide);

    final aboutDeveloper =
        AboutDeveloperContent.fromJson(json['aboutDeveloper']);
    _validateAboutDeveloper(aboutDeveloper);

    return AppConfig(
      schemaVersion: version,
      app: app,
      layout: layout,
      formatting: formatting,
      strings: strings,
      deviceGuide: deviceGuide,
      aboutDeveloper: aboutDeveloper,
      meterOptions: meters,
      tariffSchedules: schedules,
    );
  }

  static AppConfig parseJsonString(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Root JSON must be an object');
    }
    return AppConfig.fromJson(decoded);
  }
}

int _readSchemaVersion(Object? value) {
  if (value == null) return 1;
  if (value is int) return value;
  if (value is num) return value.round();
  throw FormatException('schemaVersion must be a number, got: $value');
}

void _validateUiStrings(Map<String, String> strings) {
  for (final key in kRequiredUiStringKeys) {
    final v = strings[key];
    if (v == null || v.trim().isEmpty) {
      throw FormatException(
        'strings["$key"] is required and must be non-empty '
        '(see lib/config/required_config_keys.dart)',
      );
    }
  }
}

void _validateDeviceGuide(DeviceGuideContent g) {
  if (g.pageTitle.isEmpty) {
    throw const FormatException('deviceGuide.pageTitle must not be empty');
  }
  if (g.intro.isEmpty) {
    throw const FormatException('deviceGuide.intro must not be empty');
  }
  if (g.items.isEmpty) {
    throw const FormatException('deviceGuide.items must not be empty');
  }
  for (var i = 0; i < g.items.length; i++) {
    if (g.items[i].title.trim().isEmpty) {
      throw FormatException('deviceGuide.items[$i].title must not be empty');
    }
  }
}

void _validateAboutDeveloper(AboutDeveloperContent a) {
  if (a.pageTitle.isEmpty) {
    throw const FormatException('aboutDeveloper.pageTitle must not be empty');
  }
  if (a.developerName.isEmpty) {
    throw const FormatException(
      'aboutDeveloper.developerName must not be empty',
    );
  }
  final hasParagraph = a.paragraphs.any((p) => p.trim().isNotEmpty);
  if (!hasParagraph) {
    throw const FormatException(
      'aboutDeveloper.paragraphs must contain at least one non-empty entry',
    );
  }
}

void _validateLayout(LayoutSection l) {
  void check(String name, double v) {
    if (!v.isFinite || v < 0) {
      throw FormatException(
        'layout.$name must be a non-negative finite number, got $v',
      );
    }
  }

  check('pagePadding', l.pagePadding);
  check('sectionGapLarge', l.sectionGapLarge);
  check('sectionGapMedium', l.sectionGapMedium);
  check('sectionGapSmall', l.sectionGapSmall);
  check('afterInputGap', l.afterInputGap);
  check('resultTopGap', l.resultTopGap);
  check('footnoteTopGap', l.footnoteTopGap);
  check('buttonVerticalPadding', l.buttonVerticalPadding);
  check('breakdownRowVerticalPadding', l.breakdownRowVerticalPadding);
  check('dividerHeight', l.dividerHeight);
}

void _validateFormattingTemplates(FormattingSection f) {
  if (f.currencyDisplayPrefix.trim().isEmpty) {
    throw const FormatException(
      'formatting.currencyDisplayPrefix must not be empty',
    );
  }

  _requireTemplatePlaceholders(
    f.breakdownLineTemplate,
    'breakdownLineTemplate',
    const {'units', 'rate', 'currencyPrefix'},
  );
  _requireTemplatePlaceholders(
    f.totalUnitsTemplate,
    'totalUnitsTemplate',
    const {'units'},
  );
  _requireTemplatePlaceholders(
    f.totalAmountTemplate,
    'totalAmountTemplate',
    const {'currencyPrefix', 'amount'},
  );

  final br = applyTemplate(f.breakdownLineTemplate, {
    'units': '9',
    'rate': '99',
    'currencyPrefix': f.currencyDisplayPrefix,
  });
  _assertNoPlaceholderSyntax(br, 'breakdownLineTemplate');

  final tu = applyTemplate(f.totalUnitsTemplate, {'units': '9'});
  _assertNoPlaceholderSyntax(tu, 'totalUnitsTemplate');

  final ta = applyTemplate(f.totalAmountTemplate, {
    'currencyPrefix': f.currencyDisplayPrefix,
    'amount': '999',
  });
  _assertNoPlaceholderSyntax(ta, 'totalAmountTemplate');
}

void _requireTemplatePlaceholders(
  String template,
  String fieldName,
  Set<String> keys,
) {
  for (final k in keys) {
    if (!template.contains('{{$k}}')) {
      throw FormatException(
        'formatting.$fieldName must contain placeholder {{$k}}',
      );
    }
  }
}

void _assertNoPlaceholderSyntax(String rendered, String fieldName) {
  if (rendered.contains('{{')) {
    throw FormatException(
      'formatting.$fieldName still contains "{{" after substitution — '
      'check placeholder names match those in required_config_keys / README',
    );
  }
}

Color _parseHexColor(String input) {
  var hex = input.trim();
  if (hex.startsWith('#')) hex = hex.substring(1);
  if (hex.length == 6) {
    final value = int.parse(hex, radix: 16);
    return Color(0xFF000000 | value);
  }
  if (hex.length == 8) {
    final value = int.parse(hex, radix: 16);
    return Color(value);
  }
  throw FormatException('Invalid themeSeedColor: $input');
}

String _colorToHex(Color c) {
  int byte(double channel) => (channel * 255.0).round().clamp(0, 255);
  final r = byte(c.r);
  final g = byte(c.g);
  final b = byte(c.b);
  return '#${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}
