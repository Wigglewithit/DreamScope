import 'package:flutter/material.dart';
import 'dream.dart';

class WriteDreamScreen extends StatefulWidget {
  const WriteDreamScreen({super.key});

  @override
  State<WriteDreamScreen> createState() => _WriteDreamScreenState();
}

class _WriteDreamScreenState extends State<WriteDreamScreen> {
  final TextEditingController _dreamController = TextEditingController();

  void _saveDream() {
    final text = _dreamController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first.')),
      );
      return;
    }

    final newDream = Dream(text: text, date: DateTime.now());
    Navigator.pop(context, newDream); // Send the dream back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Dream')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Describe your dream from last night:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dreamController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Type your dream here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDream,
              child: const Text('Save Dream'),
            )
          ],
        ),
      ),
    );
  }
}
