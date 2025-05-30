import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart'; // Assuming HomeScreen is defined there

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _echoController;
  late AnimationController _dreamController;
  bool showDream = false;

  @override
  void initState() {
    super.initState();

    _echoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => showDream = true);
      _dreamController.forward();
    });

    _dreamController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Navigate after animation
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _echoController.dispose();
    _dreamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _echoController,
              child: !showDream
                  ? Image.asset(
                'assets/images/echozero_logo.png',
                width: 350,
              )
                  : const SizedBox.shrink(),
            ),
            if (showDream)
              FadeTransition(
                opacity: _dreamController,
                child: Image.asset(
                  'assets/images/dreamscope_logo.png',
                  height: 200,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
