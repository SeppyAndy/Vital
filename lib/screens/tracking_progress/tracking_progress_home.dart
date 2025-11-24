import 'package:flutter/material.dart';

import '../../models/progress_entry.dart';
import '../../models/user_profile.dart';
import '../../services/local_data_service.dart';

class TrackingProgressHome extends StatelessWidget {
  const TrackingProgressHome({super.key});

  @override
  Widget build(BuildContext context) {
    final user = LocalDataService.sampleUser;
    final progressEntries = LocalDataService.getSampleProgress();
    final metrics = [
      _Metric(label: 'Steps', value: '8,420'),
      _Metric(label: 'Calories burned', value: '620 kcal'),
      _Metric(label: 'Workouts this week', value: '3/4'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context, user),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: metrics
                    .map((metric) => _buildMetricCard(context, metric))
                    .toList(),
              ),
              const SizedBox(height: 16),
              _buildProgressList(context, progressEntries),
              const SizedBox(height: 16),
              _buildGraphPlaceholder(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, UserProfile user) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back, ${user.name}',
                style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.goal, style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Weight: ${user.weightKg.toStringAsFixed(1)} kg')),
                Chip(label: Text('Height: ${user.heightCm.toStringAsFixed(0)} cm')),
                Chip(label: Text('Age: ${user.age}')),
                Chip(label: Text('Level: ${user.experienceLevel}')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, _Metric metric) {
    return SizedBox(
      width: 160,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(metric.label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8),
              Text(metric.value,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressList(BuildContext context, List<ProgressEntry> entries) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress over time',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Last 2 weeks',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...entries.map((entry) => _ProgressRow(entry: entry)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphPlaceholder(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trend graph placeholder',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'This area will display charts for weight, volume, and readiness once data syncing is enabled.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.entry});

  final ProgressEntry entry;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.label, style: textTheme.titleMedium),
                Text(entry.value, style: textTheme.bodyMedium),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(entry.change, style: textTheme.bodySmall),
              Text(
                _formatDate(entry.date),
                style: textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _Metric {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});
}
