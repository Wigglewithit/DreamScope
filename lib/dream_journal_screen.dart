import 'package:flutter/material.dart';
import 'dream.dart';

class DreamJournalScreen extends StatelessWidget {
  final List<Dream> dreamList;

  const DreamJournalScreen({super.key, required this.dreamList});

  @override
  Widget build(BuildContext context) {
    final sortedDreams = [...dreamList]
      ..sort((a, b) => b.date.compareTo(a.date)); // newest first

    return Scaffold(
      appBar: AppBar(title: const Text("Dream Journal")),
      body: sortedDreams.isEmpty
          ? const Center(child: Text("No dreams stored yet."))
          : ListView.builder(
        itemCount: sortedDreams.length,
        itemBuilder: (context, index) {
          final dream = sortedDreams[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(getDreamLabel(dream)),
              subtitle: Text(
                '${dream.date.year}-${dream.date.month.toString().padLeft(2, '0')}-${dream.date.day.toString().padLeft(2, '0')}',
              ),
            ),
          );
        },
      ),
    );
  }
}
