import 'dart:convert';

class Dream {
  final String text;
  final DateTime date;
  final String? aiTitle; // Optional AI-generated title

  Dream({
    required this.text,
    required this.date,
    this.aiTitle,
  });

  // Convert a Dream to a Map
  Map<String, dynamic> toJson() => {
    'text': text,
    'date': date.toIso8601String(),
    'aiTitle': aiTitle,
  };

  // Convert a Map to a Dream
  factory Dream.fromJson(Map<String, dynamic> json) => Dream(
    text: json['text'],
    date: DateTime.parse(json['date']),
    aiTitle: json['aiTitle'], // Will be null if not present
  );

  // Convert List<Dream> to JSON String
  static String encodeList(List<Dream> dreams) => json.encode(
    dreams.map((dream) => dream.toJson()).toList(),
  );

  // Convert JSON String back to List<Dream>
  static List<Dream> decodeList(String dreamsJson) =>
      (json.decode(dreamsJson) as List)
          .map((item) => Dream.fromJson(item))
          .toList();
}
String getDreamLabel(Dream dream) {
  if (dream.aiTitle != null && dream.aiTitle!.isNotEmpty) {
    return dream.aiTitle!;
  } else {
    final words = dream.text.split(' ');
    return words.take(5).join(' ') + (words.length > 5 ? '...' : '');
  }
}
