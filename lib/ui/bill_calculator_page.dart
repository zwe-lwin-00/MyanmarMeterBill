import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../calculator/electric_bill_calculator.dart';
import '../config/app_config.dart';
import '../config/app_config_scope.dart';

class BillCalculatorPage extends StatefulWidget {
  const BillCalculatorPage({super.key});

  @override
  State<BillCalculatorPage> createState() => _BillCalculatorPageState();
}

class _BillCalculatorPageState extends State<BillCalculatorPage> {
  final _unitsController = TextEditingController();
  final _calculator = const ElectricBillCalculator();

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
    super.dispose();
  }

  void _calculate() {
    final config = AppConfigScope.of(context);
    final raw = _unitsController.text.trim();
    final units = int.tryParse(raw);
    setState(() {
      if (raw.isEmpty || units == null || units < 0) {
        _inputError = config.string('input_error');
        _result = null;
        return;
      }
      _inputError = null;
      final meterId = _selectedMeterId ?? config.meterOptions.first.id;
      final tiers = config.tiersForMeterId(meterId);
      _result = _calculator.calculate(units, tiers);
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = AppConfigScope.of(context);
    final layout = config.layout;
    final formatting = config.formatting;
    final kyatsFormat = NumberFormat(formatting.integerNumberPattern);
    final meterId = _selectedMeterId ?? config.meterOptions.first.id;
    final selectedOption = config.meterOptions.firstWhere((o) => o.id == meterId);

    return Scaffold(
      appBar: AppBar(
        title: Text(config.app.navigatorTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(layout.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                config.string('page_intro'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: layout.sectionGapLarge),
              _MeterSelector(
                config: config,
                selectedId: meterId,
                onChanged: (id) {
                  setState(() {
                    _selectedMeterId = id;
                    _result = null;
                  });
                },
              ),
              SizedBox(height: layout.sectionGapSmall),
              Text(
                selectedOption.detailLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: layout.sectionGapLarge + layout.sectionGapMedium),
              TextField(
                controller: _unitsController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: config.string('units_label'),
                  hintText: config.string('units_hint'),
                  border: const OutlineInputBorder(),
                  errorText: _inputError,
                ),
                onSubmitted: (_) => _calculate(),
              ),
              SizedBox(height: layout.afterInputGap),
              FilledButton(
                onPressed: _calculate,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: layout.buttonVerticalPadding,
                  ),
                  child: Text(config.string('calculate_button')),
                ),
              ),
              if (_result != null) ...[
                SizedBox(height: layout.resultTopGap),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: EdgeInsets.all(layout.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.string('result_heading'),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: layout.sectionGapSmall),
                        Text(
                          config.formatTotalAmount(
                            kyatsFormat.format(_result!.totalKyats),
                          ),
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        Text(
                          config.formatTotalUnits(_result!.totalUnits),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Divider(height: layout.dividerHeight),
                        Text(
                          config.string('breakdown_heading'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(height: layout.sectionGapSmall),
                        ..._result!.breakdown.map(
                          (row) => Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: layout.breakdownRowVerticalPadding,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    config.formatBreakdownLine(
                                      unitsInTier: row.kwhInTier,
                                      kyatsPerKwh: row.kyatsPerKwh,
                                    ),
                                  ),
                                ),
                                Text(
                                  config.formatTotalAmount(
                                    kyatsFormat.format(row.subtotalKyats),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: layout.footnoteTopGap),
                Text(
                  config.string('footnote'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MeterSelector extends StatelessWidget {
  const _MeterSelector({
    required this.config,
    required this.selectedId,
    required this.onChanged,
  });

  final AppConfig config;
  final String selectedId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = config.meterOptions;
    if (options.isEmpty) {
      return const SizedBox.shrink();
    }
    if (options.length >= 2) {
      return SegmentedButton<String>(
        segments: options
            .map(
              (o) => ButtonSegment<String>(
                value: o.id,
                label: Text(
                  o.segmentLabel,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        selected: {selectedId},
        onSelectionChanged: (selection) => onChanged(selection.first),
      );
    }
    final only = options.first;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        only.detailLabel,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
