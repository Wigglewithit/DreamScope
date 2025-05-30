import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';
import 'write_dream_screen.dart';
import 'dream.dart';
import 'dream_journal_screen.dart';

void main() {
  runApp(const DreamRecallTrainerApp());
}

class DreamRecallTrainerApp extends StatelessWidget {
  const DreamRecallTrainerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dreamscope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E21),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const SplashScreen(),

    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Dream> dreamList = [];

  @override
  void initState() {
    super.initState();
    _loadDreams();
  }

  Future<void> _loadDreams() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedDreams = prefs.getString('dreamList');
      if (storedDreams != null) {
        setState(() {
          dreamList.addAll(Dream.decodeList(storedDreams));
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load dreams: $e');
      }
    }
  }

  Future<void> _storeDreams() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = await compute(Dream.encodeList, dreamList);
      await prefs.setString('dreamList', jsonString);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dreams saved!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save dreams: $e')),
        );
      }
    }
  }

  Future<void> _navigateAndAddDream(BuildContext context) async {
    final newDream = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WriteDreamScreen()),
    );
    if (newDream != null && newDream is Dream) {
      setState(() {
        dreamList.add(newDream);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/dreamscope_logo.png',
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 32),

            const SizedBox(height: 32),


            _buildGradientButton(
              context,
              label: 'Write a Dream',
              onPressed: () => _navigateAndAddDream(context),
            ),
            const SizedBox(height: 20),
            _buildGradientButton(
              context,
              label: 'View My Dreams',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DreamJournalScreen(dreamList: dreamList),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildGradientButton(
              context,
              label: 'Store Dreams',
              onPressed: _storeDreams,
            ),
            const SizedBox(height: 30),
            Expanded(child: DreamListWidget(dreamList: dreamList)),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: const Color(0xFF1E2A3A), // Softer tone
          elevation: 2,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class DreamListWidget extends StatelessWidget {
  final List<Dream> dreamList;

  const DreamListWidget({super.key, required this.dreamList});

  @override
  Widget build(BuildContext context) {
    if (dreamList.isEmpty) {
      return const Text(
        "You haven't written a dream today.",
        style: TextStyle(fontSize: 16, color: Colors.white),
      );
    }

    return ListView.builder(
      itemCount: dreamList.length,
      itemBuilder: (context, index) {
        final dream = dreamList[index];
        return Card(
          color: const Color(0xFF243447),
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(
              getDreamLabel(dream),
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '${dream.date.year}-${dream.date.month.toString().padLeft(2, '0')}-${dream.date.day.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        );
      },
    );
  }
}
