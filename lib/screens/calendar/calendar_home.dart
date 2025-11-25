import 'package:flutter/material.dart';

class CalendarHome extends StatelessWidget {
  const CalendarHome({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstWeekday = DateTime(now.year, now.month, 1).weekday; // 1 = Monday
    final cells = <int?>[
      ...List<int?>.filled(firstWeekday - 1, null),
      ...List.generate(daysInMonth, (index) => index + 1),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _monthLabel(now),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Hook up session creation workflow.
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add session'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildWeekdayHeader(context),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: cells.map((day) {
                  if (day == null) {
                    return _DayCell.empty();
                  }
                  final date = DateTime(now.year, now.month, day);
                  final isToday = _isSameDay(date, now);
                  final isTrainingDay =
                      [DateTime.monday, DateTime.wednesday, DateTime.friday].contains(date.weekday);
                  return _DayCell(
                    day: day,
                    isToday: isToday,
                    isTrainingDay: isTrainingDay,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                "Today's focus",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                tileColor: Color(0xFFF2F4F7),
                leading: Icon(Icons.flag),
                title: Text('Lower body strength session'),
                subtitle: Text('Warm-up, squats, lunges, and core stability'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthLabel(DateTime date) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${monthNames[date.month - 1]} ${date.year}';
  }

  Widget _buildWeekdayHeader(BuildContext context) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ))
          .toList(),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({this.day, this.isToday = false, this.isTrainingDay = false});

  const _DayCell.empty()
      : day = null,
        isToday = false,
        isTrainingDay = false;

  final int? day;
  final bool isToday;
  final bool isTrainingDay;

  @override
  Widget build(BuildContext context) {
    final bgColor = isToday
        ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
        : isTrainingDay
            ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4);
    final textColor = isToday
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 16 * 2 - 8 * 6) / 7,
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: day == null ? Colors.transparent : bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(day?.toString() ?? '', style: TextStyle(color: textColor)),
          ),
        ),
      ),
    );
  }
}
