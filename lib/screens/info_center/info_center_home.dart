import 'package:flutter/material.dart';

import '../../services/local_data_service.dart';

class InfoCenterHome extends StatelessWidget {
  const InfoCenterHome({super.key});

  @override
  Widget build(BuildContext context) {
    final topics = LocalDataService.getInfoTopics();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Center'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side:
                  BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            child: ListTile(
              title: Text(topic['title'] ?? ''),
              subtitle: Text(topic['summary'] ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => InfoDetailPage(
                    title: topic['title'] ?? '',
                    summary: topic['summary'] ?? '',
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class InfoDetailPage extends StatelessWidget {
  const InfoDetailPage({super.key, required this.title, required this.summary});

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
            const SizedBox(height: 8),
            Text(summary, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side:
                    BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Later, this area will be replaced by curated research summaries and expert insights to guide your decisions.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
