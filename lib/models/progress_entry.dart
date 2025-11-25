class ProgressEntry {
  final String id;
  final String label;
  final String value;
  final String change;
  final DateTime date;

  const ProgressEntry({
    required this.id,
    required this.label,
    required this.value,
    required this.change,
    required this.date,
  });

  factory ProgressEntry.fromJson(Map<String, dynamic> json) {
    return ProgressEntry(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
      change: json['change'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
      'change': change,
      'date': date.toIso8601String(),
    };
  }
}
