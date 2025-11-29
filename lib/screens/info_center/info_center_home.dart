import 'package:flutter/material.dart';

import '../../services/local_data_service.dart';
import '../../services/user_settings_service.dart';
import '../../widgets/app_section_header.dart';

class InfoCenterHome extends StatefulWidget {
  const InfoCenterHome({super.key});

  @override
  State<InfoCenterHome> createState() => _InfoCenterHomeState();
}

class _InfoCenterHomeState extends State<InfoCenterHome> {
  late final List<Map<String, String>> _allTopics =
      LocalDataService.getInfoTopics();
  late List<Map<String, String>> _filteredTopics;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // TODO: Replace static list with backend search results.
    _filteredTopics = List<Map<String, String>>.from(_allTopics);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      final query = value.toLowerCase();
      _filteredTopics = _allTopics.where((topic) {
        final title = (topic['title'] ?? '').toLowerCase();
        final summary = (topic['summary'] ?? '').toLowerCase();
        return title.contains(query) || summary.contains(query);
      }).toList();
    });
  }

  bool _topicMatchesGoal(String goal, Map<String, String> topic) {
    final text = ((topic['title'] ?? '') + ' ' + (topic['summary'] ?? ''))
        .toLowerCase();
    final g = goal.toLowerCase();

    if (g.contains('lose') || g.contains('fat')) {
      return text.contains('fat') ||
          text.contains('weight loss') ||
          text.contains('calorie') ||
          text.contains('deficit');
    } else if (g.contains('muscle')) {
      return text.contains('muscle') ||
          text.contains('hypertrophy') ||
          text.contains('strength') ||
          text.contains('protein');
    } else if (g.contains('health')) {
      return text.contains('health') ||
          text.contains('longevity') ||
          text.contains('heart') ||
          text.contains('wellbeing');
    }

    return text.contains('health') || text.contains('fitness');
  }

  @override
  Widget build(BuildContext context) {
    final settings = UserSettingsService.instance.settings;
    final String userGoal =
        (settings.goal?.isNotEmpty == true) ? settings.goal! : 'Improve health';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Center'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ListView(
            children: [
              const AppSectionHeader(
                title: 'Browse topics',
                subtitle:
                    'Curated topics to help you train smarter and recover better.',
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your current focus',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userGoal,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "We'll highlight topics that may be more relevant to your goal.",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search topics...',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 16),
              if (_filteredTopics.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.menu_book_outlined, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'No topics found',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try a different search term.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              else
                ..._filteredTopics.map(
                  (topic) {
                    final matchesGoal = _topicMatchesGoal(userGoal, topic);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: matchesGoal
                            ? Theme.of(context)
                                .colorScheme
                                .secondaryContainer
                                .withOpacity(0.2)
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.menu_book_outlined),
                          title: Text(topic['title'] ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(topic['summary'] ?? ''),
                              if (matchesGoal) ...[
                                const SizedBox(height: 4),
                                Wrap(
                                  spacing: 6,
                                  children: const [
                                    Chip(
                                      label: Text('Recommended for your goal'),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => InfoTopicDetailPage(
                                title: topic['title'] ?? '',
                                summary: topic['summary'] ?? '',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoTopicDetailPage extends StatelessWidget {
  const InfoTopicDetailPage({
    super.key,
    required this.title,
    required this.summary,
  });

  final String title;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              summary,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Text(
              // TODO: Replace placeholder content with vetted research summaries.
              'This section will later be replaced with trusted, up-to-date research summaries tailored to the user\'s goals.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
