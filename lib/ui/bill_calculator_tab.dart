import 'dart:ui' show FontFeature;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../calculator/electric_bill_calculator.dart';
import '../config/app_config.dart';
import '../config/app_config_scope.dart';

class BillCalculatorTab extends StatefulWidget {
  const BillCalculatorTab({
    super.key,
    required this.layoutPadding,
  });

  final double layoutPadding;

  @override
  State<BillCalculatorTab> createState() => _BillCalculatorTabState();
}

class _BillCalculatorTabState extends State<BillCalculatorTab> {
  final _unitsController = TextEditingController();
  final _unitsFocus = FocusNode();
  final _scrollController = ScrollController();
  final _calculator = const ElectricBillCalculator();
  final _resultKey = GlobalKey();

  String? _selectedMeterId;
  BillResult? _result;
  String? _inputError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final options = AppConfigScope.of(context).meterOptions;
    if (_selectedMeterId == null && options.isNotEmpty) {
      _selectedMeterId = options.first.id;
    } else if (_selectedMeterId != null &&
        !options.any((o) => o.id == _selectedMeterId)) {
      _selectedMeterId = options.isNotEmpty ? options.first.id : null;
    }
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _unitsFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  TextStyle _tabularAmountStyle(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    return base.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
      fontWeight: FontWeight.w600,
    );
  }

  void _clear() {
    _unitsController.clear();
    _unitsFocus.unfocus();
    setState(() {
      _result = null;
      _inputError = null;
    });
  }

  void _calculate() {
    final config = AppConfigScope.of(context);
    final raw = _unitsController.text.trim();
    final units = int.tryParse(raw);
    BillResult? next;
    setState(() {
      if (raw.isEmpty || units == null || units < 0) {
        _inputError = config.string('input_error');
        _result = null;
        return;
      }
      if (units == 0) {
        _inputError = config.string('input_error_zero');
        _result = null;
        return;
      }
      _inputError = null;
      final meterId = _selectedMeterId ?? config.meterOptions.first.id;
      final tiers = config.tiersForMeterId(meterId);
      next = _calculator.calculate(units, tiers);
      _result = next;
    });
    if (next != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final ctx = _resultKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            alignment: 0.12,
          );
        }
      });
    }
  }

  bool get _scrollbarInteractive {
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux =>
        true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfigScope.of(context);
    final layout = config.layout;
    final formatting = config.formatting;
    final kyatsFormat = NumberFormat(formatting.integerNumberPattern);
    final meterId = _selectedMeterId ?? config.meterOptions.first.id;
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: _scrollbarInteractive,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(widget.layoutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                Text(
                  config.string('page_intro'),
                  style: textTheme.titleMedium?.copyWith(height: 1.35),
                ),
                SizedBox(height: layout.sectionGapLarge),
                Text(
                  config.string('meter_section_label'),
                  style: textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: layout.sectionGapSmall),
                _MeterOptionCards(
                  config: config,
                  selectedId: meterId,
                  gap: layout.sectionGapSmall,
                  onChanged: (id) {
                    setState(() {
                      _selectedMeterId = id;
                      _result = null;
                    });
                  },
                ),
                SizedBox(height: layout.sectionGapLarge + layout.sectionGapMedium),
                TextField(
                  controller: _unitsController,
                  focusNode: _unitsFocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: config.string('units_label'),
                    hintText: config.string('units_hint'),
                    helperText: config.string('units_helper'),
                    helperMaxLines: 3,
                    border: const OutlineInputBorder(),
                    errorText: _inputError,
                  ),
                  onSubmitted: (_) => _calculate(),
                ),
                SizedBox(height: layout.afterInputGap),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final narrow = constraints.maxWidth < 400;
                    final calc = FilledButton(
                      onPressed: _calculate,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: layout.buttonVerticalPadding,
                        ),
                        child: Text(config.string('calculate_button')),
                      ),
                    );
                    final clear = OutlinedButton(
                      onPressed: _clear,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: layout.buttonVerticalPadding,
                        ),
                        child: Text(config.string('clear_button')),
                      ),
                    );
                    if (narrow) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          calc,
                          SizedBox(height: layout.sectionGapSmall),
                          clear,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        Expanded(flex: 3, child: calc),
                        SizedBox(width: layout.sectionGapMedium),
                        Expanded(flex: 2, child: clear),
                      ],
                    );
                  },
                ),
                if (_result == null) ...[
                  SizedBox(height: layout.resultTopGap),
                  _EmptyPreviewCard(
                    text: config.string('result_empty_hint'),
                    padding: layout.pagePadding,
                  ),
                ] else ...[
                  SizedBox(height: layout.resultTopGap),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.06),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(
                        '${_result!.totalKyats}_${_result!.totalUnits}_${_result!.uncapturedKwh}_$meterId',
                      ),
                      child: _ResultPanel(
                        resultKey: _resultKey,
                        config: config,
                        result: _result!,
                        layout: layout,
                        kyatsFormat: kyatsFormat,
                        tabularStyle: _tabularAmountStyle(context),
                        estimateChipLabel: config.string('estimate_chip'),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: layout.footnoteTopGap),
                Text(
                  config.string('footnote'),
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _MeterOptionCards extends StatelessWidget {
  const _MeterOptionCards({
    required this.config,
    required this.selectedId,
    required this.onChanged,
    required this.gap,
  });

  final AppConfig config;
  final String selectedId;
  final ValueChanged<String> onChanged;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final options = config.meterOptions;
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    final radii = BorderRadius.circular(16);

    if (options.length == 2) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MeterTile(
              option: options[0],
              groupValue: selectedId,
              borderRadius: radii,
              scheme: scheme,
              compact: true,
              onSelect: () => onChanged(options[0].id),
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: _MeterTile(
              option: options[1],
              groupValue: selectedId,
              borderRadius: radii,
              scheme: scheme,
              compact: true,
              onSelect: () => onChanged(options[1].id),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          _MeterTile(
            option: options[i],
            groupValue: selectedId,
            borderRadius: radii,
            scheme: scheme,
            compact: false,
            onSelect: () => onChanged(options[i].id),
          ),
        ],
      ],
    );
  }
}

class _MeterTile extends StatelessWidget {
  const _MeterTile({
    required this.option,
    required this.groupValue,
    required this.borderRadius,
    required this.scheme,
    required this.compact,
    required this.onSelect,
  });

  final MeterOption option;
  final String groupValue;
  final BorderRadius borderRadius;
  final ColorScheme scheme;
  final bool compact;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final selected = option.id == groupValue;
    final borderColor = selected ? scheme.primary : scheme.outlineVariant;
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = compact
        ? textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)
        : textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600);
    final subtitleStyle = textTheme.bodySmall?.copyWith(
      color: scheme.onSurfaceVariant,
      fontSize: compact ? 11.5 : null,
    );

    return Material(
      color: selected
          ? Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.12),
              scheme.surface,
            )
          : scheme.surfaceContainerHighest,
      elevation: selected ? 1 : 0,
      shadowColor: scheme.shadow.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(color: borderColor, width: selected ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: RadioListTile<String>(
        value: option.id,
        groupValue: groupValue,
        onChanged: (_) => onSelect(),
        visualDensity:
            compact ? VisualDensity.compact : VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        title: Text(
          option.segmentLabel,
          maxLines: compact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        subtitle: Text(
          option.detailLabel,
          maxLines: compact ? 2 : 3,
          overflow: TextOverflow.ellipsis,
          style: subtitleStyle,
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 12,
          vertical: compact ? 4 : 6,
        ),
      ),
    );
  }
}

class _EmptyPreviewCard extends StatelessWidget {
  const _EmptyPreviewCard({
    required this.text,
    required this.padding,
  });

  final String text;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 22,
              color: scheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.resultKey,
    required this.config,
    required this.result,
    required this.layout,
    required this.kyatsFormat,
    required this.tabularStyle,
    required this.estimateChipLabel,
  });

  final GlobalKey resultKey;
  final AppConfig config;
  final BillResult result;
  final LayoutSection layout;
  final NumberFormat kyatsFormat;
  final TextStyle tabularStyle;
  final String estimateChipLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final totalStr = config.formatTotalAmount(
      kyatsFormat.format(result.totalKyats),
    );

    return Card(
      key: resultKey,
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(layout.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  config.string('result_heading'),
                  style: textTheme.titleMedium,
                ),
                Chip(
                  avatar: Icon(
                    Icons.info_outline,
                    size: 18,
                    color: scheme.secondary,
                  ),
                  label: Text(estimateChipLabel),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: BorderSide(color: scheme.outlineVariant),
                  backgroundColor:
                      scheme.secondaryContainer.withValues(alpha: 0.35),
                ),
              ],
            ),
            SizedBox(height: layout.sectionGapSmall),
            Semantics(
              header: true,
              liveRegion: true,
              label: '${config.string('result_heading')}: $totalStr',
              child: Text(
                totalStr,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Text(
              config.formatTotalUnits(result.totalUnits),
              style: textTheme.bodyMedium,
            ),
            if (result.uncapturedKwh > 0) ...[
              SizedBox(height: layout.sectionGapSmall),
              Semantics(
                liveRegion: true,
                container: true,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: scheme.onErrorContainer,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            config.fillString(
                              'tier_incomplete_warning',
                              {'kwh': '${result.uncapturedKwh}'},
                            ),
                            style: textTheme.bodySmall?.copyWith(
                              color: scheme.onErrorContainer,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            Divider(height: layout.dividerHeight),
            Text(
              config.string('breakdown_heading'),
              style: textTheme.titleSmall,
            ),
            SizedBox(height: layout.sectionGapSmall),
            ...result.breakdown.map(
              (row) => MergeSemantics(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: layout.breakdownRowVerticalPadding,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          config.formatBreakdownLine(
                            unitsInTier: row.kwhInTier,
                            kyatsPerKwh: row.kyatsPerKwh,
                          ),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        config.formatTotalAmount(
                          kyatsFormat.format(row.subtotalKyats),
                        ),
                        style: tabularStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
