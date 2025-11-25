import 'package:flutter/material.dart';

import '../../models/progress_entry.dart';
import '../../models/user_profile.dart';
import '../../services/local_data_service.dart';
import '../../widgets/app_section_header.dart';

class TrackingProgressHome extends StatelessWidget {
  const TrackingProgressHome({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with API data when backend is connected.
    final user = LocalDataService.sampleUser;
    // TODO: Add refresh logic to sync with wearable data sources.
    final progressEntries = LocalDataService.getSampleProgress();
    final metrics = const [
      _Metric(label: 'Steps', value: '8,420'),
      _Metric(label: 'Calories burned', value: '620 kcal'),
      _Metric(label: 'Workouts this week', value: '3/4'),
      _Metric(label: 'Sleep', value: '7h 45m'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        actions: [
          IconButton(
            tooltip: 'Profile & Settings',
            icon: const Icon(Icons.person_outline),
            onPressed: () => _openProfileSheet(context, user),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HeaderCard(user: user),
            const AppSectionHeader(
              title: "Today's snapshot",
              subtitle: 'Key metrics for today.',
            ),
            _MetricSection(metrics: metrics),
            const AppSectionHeader(title: 'Progress over time'),
            _ProgressSection(entries: progressEntries),
            const AppSectionHeader(
              title: 'Trends preview',
              subtitle:
                  'Visual summaries will highlight weight, strength, and more.',
            ),
            _GraphPlaceholder(),
          ],
        ),
      ),
    );
  }

  void _openProfileSheet(BuildContext context, UserProfile user) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _ProfileBottomSheet(
          user: user,
          onOptionSelected: (message) {
            Navigator.of(sheetContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${user.name}',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(user.goal, style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AssistChip(label: Text('Age: ${user.age}')),
                AssistChip(
                    label: Text('Height: ${user.heightCm.toStringAsFixed(0)} cm')),
                AssistChip(
                    label: Text('Weight: ${user.weightKg.toStringAsFixed(1)} kg')),
                AssistChip(label: Text('Level: ${user.experienceLevel}')),
              ],
            ),
            // TODO: Allow user to edit profile and goal preferences.
          ],
        ),
      ),
    );
  }
}

class _MetricSection extends StatelessWidget {
  const _MetricSection({required this.metrics});

  final List<_Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: metrics
          .map(
            (metric) => _MetricCard(metric: metric),
          )
          .toList(),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _Metric metric;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return SizedBox(
      width: 160,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outline),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
              Text(
                metric.value,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({required this.entries});

  final List<ProgressEntry> entries;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: outline),
      ),
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++)
            _ProgressEntryTile(
              entry: entries[i],
              isLast: i == entries.length - 1,
            ),
        ],
      ),
    );
  }
}

class _ProgressEntryTile extends StatelessWidget {
  const _ProgressEntryTile({required this.entry, required this.isLast});

  final ProgressEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        ListTile(
          title: Text(entry.label),
          subtitle: Text(_formatDate(entry.date)),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                entry.change,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _changeColor(entry.change, scheme),
                    ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: scheme.outlineVariant.withOpacity(0.6)),
      ],
    );
  }

  Color _changeColor(String change, ColorScheme scheme) {
    if (change.trim().startsWith('-')) {
      return scheme.error;
    }
    if (change.trim().startsWith('+')) {
      return scheme.tertiary;
    }
    return scheme.onSurfaceVariant;
  }

  String _formatDate(DateTime date) {
    return date.toString().split(' ').first;
  }
}

class _ProfileBottomSheet extends StatelessWidget {
  const _ProfileBottomSheet({required this.user, required this.onOptionSelected});

  final UserProfile user;
  final ValueChanged<String> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final outline = Theme.of(context).colorScheme.outlineVariant;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    _initials(user.name),
                    style: textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(user.goal, style: textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(label: 'Age: ${user.age}'),
                _InfoChip(label: 'Height: ${user.heightCm.toStringAsFixed(0)} cm'),
                _InfoChip(label: 'Weight: ${user.weightKg.toStringAsFixed(1)} kg'),
                _InfoChip(label: 'Experience: ${user.experienceLevel}'),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: outline),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SettingsTile(
                    icon: Icons.flag_outlined,
                    label: 'Update goals',
                    onTap: () => onOptionSelected(
                        'This setting will be available in a future update.'),
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.person_outline,
                    label: 'Edit profile',
                    onTap: () => onOptionSelected(
                        'This setting will be available in a future update.'),
                  ),
                  const Divider(height: 1),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    label: 'Notification preferences',
                    onTap: () => onOptionSelected(
                        'This setting will be available in a future update.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Chip(
      label: Text(label),
      side: BorderSide(color: outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: onTap,
    );
  }
}

class _GraphPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(context).colorScheme.outlineVariant;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: outline),
      ),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Graph placeholder – weight, strength, and other metrics will be visualized here.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric {
  final String label;
  final String value;

  const _Metric({required this.label, required this.value});
}
