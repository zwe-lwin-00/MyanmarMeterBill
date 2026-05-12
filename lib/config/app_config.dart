import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/tariff_tier.dart';
import 'string_template.dart';

class AppSection {
  const AppSection({
    required this.materialTitle,
    required this.navigatorTitle,
    required this.themeSeedColor,
    required this.useMaterial3,
  });

  final String materialTitle;
  final String navigatorTitle;
  final Color themeSeedColor;
  final bool useMaterial3;

  Map<String, Object?> toJson() => {
        'materialTitle': materialTitle,
        'navigatorTitle': navigatorTitle,
        'themeSeedColor': _colorToHex(themeSeedColor),
        'useMaterial3': useMaterial3,
      };

  static AppSection fromJson(Map<String, dynamic> json) {
    final hex = json['themeSeedColor'] as String? ?? '#1E88E5';
    return AppSection(
      materialTitle: json['materialTitle'] as String? ?? 'App',
      navigatorTitle: json['navigatorTitle'] as String? ?? 'App',
      themeSeedColor: _parseHexColor(hex),
      useMaterial3: json['useMaterial3'] as bool? ?? true,
    );
  }
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
    if (json == null) return FormattingSection.defaults();
    return FormattingSection(
      currencyDisplayPrefix:
          json['currencyDisplayPrefix'] as String? ?? 'Ks ',
      integerNumberPattern:
          json['integerNumberPattern'] as String? ?? '#,##0',
      breakdownLineTemplate: json['breakdownLineTemplate'] as String? ??
          '{{units}} kWh × {{rate}} {{currencyPrefix}}',
      totalUnitsTemplate: json['totalUnitsTemplate'] as String? ??
          'Total {{units}} kWh',
      totalAmountTemplate: json['totalAmountTemplate'] as String? ??
          '{{currencyPrefix}}{{amount}}',
    );
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
  });

  final String id;
  final String segmentLabel;
  final String detailLabel;
  final String tariffScheduleId;

  Map<String, Object?> toJson() => {
        'id': id,
        'segmentLabel': segmentLabel,
        'detailLabel': detailLabel,
        'tariffScheduleId': tariffScheduleId,
      };

  static MeterOption fromJson(Map<String, dynamic> json) {
    return MeterOption(
      id: json['id'] as String? ?? 'default',
      segmentLabel: json['segmentLabel'] as String? ?? json['id'] as String,
      detailLabel: json['detailLabel'] as String? ??
          json['segmentLabel'] as String? ??
          '',
      tariffScheduleId:
          json['tariffScheduleId'] as String? ?? json['id'] as String,
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
    required this.meterOptions,
    required this.tariffSchedules,
  });

  final int schemaVersion;
  final AppSection app;
  final LayoutSection layout;
  final FormattingSection formatting;
  final Map<String, String> strings;
  final List<MeterOption> meterOptions;
  final Map<String, List<TariffTier>> tariffSchedules;

  String string(String key) => strings[key] ?? key;

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
    final version = json['schemaVersion'] as int? ?? 1;
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

    final scheduleJson =
        json['tariffSchedules'] as Map<String, dynamic>? ?? {};
    final schedules = <String, List<TariffTier>>{};
    for (final e in scheduleJson.entries) {
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
        return TariffTier(
          capacityKwh: cap.round(),
          kyatsPerKwh: rate.round(),
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

    return AppConfig(
      schemaVersion: version,
      app: AppSection.fromJson(appMap),
      layout: LayoutSection.fromJson(json['layout'] as Map<String, dynamic>?),
      formatting: FormattingSection.fromJson(
        json['formatting'] as Map<String, dynamic>?,
      ),
      strings: strings,
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
  final v = c.value;
  final r = (v >> 16) & 0xff;
  final g = (v >> 8) & 0xff;
  final b = v & 0xff;
  return '#${r.toRadixString(16).padLeft(2, '0')}'
      '${g.toRadixString(16).padLeft(2, '0')}'
      '${b.toRadixString(16).padLeft(2, '0')}';
}
