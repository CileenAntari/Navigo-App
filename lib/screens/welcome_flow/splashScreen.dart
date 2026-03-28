import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome.dart';

class NavigoSplashScreen extends StatefulWidget {
  const NavigoSplashScreen({super.key});

  @override
  State<NavigoSplashScreen> createState() => _NavigoSplashScreenState();
}

class _NavigoSplashScreenState extends State<NavigoSplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF9BC58),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Image(image: AssetImage("images/logo.png"), width: 220),
              SizedBox(height: 20),
              Text(
                'Navigo-وصلني',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Smart Transportation Platform',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
