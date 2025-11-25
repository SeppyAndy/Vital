import 'package:flutter/material.dart';

import '../../services/local_data_service.dart';
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

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: const [
                      Icon(Icons.info_outline),
                      SizedBox(height: 8),
                      Text('No topics match your search yet.'),
                    ],
                  ),
                )
              else
                ..._filteredTopics.map(
                  (topic) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.menu_book_outlined),
                        title: Text(topic['title'] ?? ''),
                        subtitle: Text(topic['summary'] ?? ''),
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
                  ),
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
