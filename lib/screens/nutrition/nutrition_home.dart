import 'package:flutter/material.dart';

import '../../models/nutrition_plan.dart';
import '../../services/local_data_service.dart';

class NutritionHome extends StatelessWidget {
  const NutritionHome({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = LocalDataService.sampleNutritionPlan;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Nutrition',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Today\'s macro breakdown based on your current plan.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _MacroSummaryCard(plan: plan),
            const SizedBox(height: 16),
            Text(
              'Guidance',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _GuidanceList(notes: plan.notes),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.icon(
                onPressed: () {
                  // TODO: Connect to food scanner / manual entry workflows.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Food scanning and logging will be added in a future update.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Scan / add food'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroSummaryCard extends StatelessWidget {
  const _MacroSummaryCard({required this.plan});

  final NutritionPlan plan;

  @override
  Widget build(BuildContext context) {
    final proteinKcal = plan.protein * 4;
    final carbsKcal = plan.carbs * 4;
    final fatsKcal = plan.fats * 9;
    final totalMacroKcal = proteinKcal + carbsKcal + fatsKcal;

    int percentage(int macroKcal) {
      if (totalMacroKcal == 0) return 0;
      return ((macroKcal / totalMacroKcal) * 100).round();
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${plan.calories} kcal',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MacroChip(label: 'Protein', value: '${plan.protein} g'),
                _MacroChip(label: 'Carbs', value: '${plan.carbs} g'),
                _MacroChip(label: 'Fats', value: '${plan.fats} g'),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _MacroPercentageText(
                  label: 'Protein',
                  percent: percentage(proteinKcal),
                  color: colorScheme.primary,
                ),
                _MacroPercentageText(
                  label: 'Carbs',
                  percent: percentage(carbsKcal),
                  color: colorScheme.secondary,
                ),
                _MacroPercentageText(
                  label: 'Fats',
                  percent: percentage(fatsKcal),
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MacroPercentageText extends StatelessWidget {
  const _MacroPercentageText({
    required this.label,
    required this.percent,
    required this.color,
  });

  final String label;
  final int percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text('$label ~${percent}%'),
      ],
    );
  }
}

class _GuidanceList extends StatelessWidget {
  const _GuidanceList({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        children: notes
            .map(
              (note) => ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: Text(note),
              ),
            )
            .toList(),
      ),
    );
  }
}
