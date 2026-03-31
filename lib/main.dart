import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_flow/welcome.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase only once (avoids [core/duplicate-app] on some setups).
  /*if (Firebase.apps.isEmpty) { 
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    
  }*/
  await Firebase.initializeApp(demoProjectId: "demo-Navigo");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

/// ✅ Splash Screen (NO Firebase here)
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  Future<void> startApp() async {
    // wait 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // ✅ Debug (optional)
    print("Navigating to onboarding...");

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [NavigoColors.primaryAmber, NavigoColors.backgroundLight],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: const AssetImage("assets/images/logo.png"),
                  width: 220,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Navigo وصلني",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Smart Transportation Platform",
                  style: NavigoTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
