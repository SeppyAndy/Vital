import 'package:flutter/material.dart';

class CalendarHome extends StatefulWidget {
  const CalendarHome({super.key});

  @override
  State<CalendarHome> createState() => _CalendarHomeState();
}

class _CalendarHomeState extends State<CalendarHome> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final selectedOrToday = _selectedDate ?? now;
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekdayIndex = (firstDayOfMonth.weekday + 6) % 7; // 0 = Mon

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            _MonthHeader(
              now: now,
              onAddSession: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Session creation will be added later.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _WeekdayHeader(color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 12),
            _buildCalendarGrid(
              now: now,
              selectedDate: selectedOrToday,
              startWeekdayIndex: startWeekdayIndex,
              daysInMonth: daysInMonth,
            ),
            const SizedBox(height: 16),
            Text(
              'Focus for ${_formatShortDate(selectedOrToday)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text("Today's focus"),
                subtitle: Text(_focusForDate(selectedOrToday)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid({
    required DateTime now,
    required DateTime selectedDate,
    required int startWeekdayIndex,
    required int daysInMonth,
  }) {
    final totalCells = startWeekdayIndex + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (rowIndex) {
        return Row(
          children: List.generate(7, (colIndex) {
            final cellIndex = rowIndex * 7 + colIndex;
            if (cellIndex < startWeekdayIndex ||
                cellIndex >= startWeekdayIndex + daysInMonth) {
              return const Expanded(
                child: SizedBox(
                  height: 44,
                ),
              );
            }
            final dayNumber = cellIndex - startWeekdayIndex + 1;
            final date = DateTime(now.year, now.month, dayNumber);
            final isToday = _isSameDay(date, now);
            final isSelected = _isSameDay(date, selectedDate);
            final isTrainingDay = date.weekday == DateTime.monday ||
                date.weekday == DateTime.wednesday ||
                date.weekday == DateTime.friday;
            return Expanded(
              child: _DayCell(
                day: dayNumber,
                isToday: isToday,
                isSelected: isSelected,
                isTrainingDay: isTrainingDay,
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                },
              ),
            );
          }),
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _formatShortDate(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday ${date.day} $month';
  }

  String _focusForDate(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Lower body strength + light cardio';
      case DateTime.wednesday:
        return 'Upper body strength';
      case DateTime.friday:
        return 'Full body conditioning';
      default:
        return 'Recovery, walking, and mobility work';
    }
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.now, required this.onAddSession});

  final DateTime now;
  final VoidCallback onAddSession;

  @override
  Widget build(BuildContext context) {
    final monthLabel = _monthLabel(now);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthLabel,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        OutlinedButton.icon(
          onPressed: onAddSession,
          icon: const Icon(Icons.add),
          label: const Text('Add session'),
        ),
      ],
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
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: color),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isToday;
  final bool isSelected;
  final bool isTrainingDay;
  final VoidCallback? onTap;

  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.isTrainingDay,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Color backgroundColor = colorScheme.surface;
    Color textColor = colorScheme.onSurface;
    BoxBorder? border;

    if (isToday) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
      border = Border.all(color: colorScheme.primaryContainer);
    } else if (isSelected) {
      backgroundColor = colorScheme.surface;
      border = Border.all(color: colorScheme.primary);
    } else if (isTrainingDay) {
      backgroundColor = colorScheme.secondaryContainer.withOpacity(0.25);
      border = Border.all(color: colorScheme.outlineVariant.withOpacity(0.5));
    } else {
      border = Border.all(color: colorScheme.outlineVariant.withOpacity(0.5));
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: border,
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
