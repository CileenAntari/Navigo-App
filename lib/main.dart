import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'screens/welcome_flow/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseCheckScreen(),
    );
  }
}

/// Firebase Check Screen
class FirebaseCheckScreen extends StatelessWidget {
  const FirebaseCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.delayed(const Duration(seconds: 3)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const OnboardingScreen();
          }
        },
      ),
    );
  }
}

/// Navigo Splash Screen
class NavigoSplashScreen extends StatelessWidget {
  const NavigoSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF9BC58),
        child: Stack(
          children: [
            /// Logo
            Positioned(
              left: 76,
              top: 201,
              child: Container(
                width: 250,
                height: 320,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://placehold.co/250x320"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            /// Title
            Positioned(
              left: 119,
              top: 537,
              child: Text(
                'Navigo-وصلني',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111827),
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            /// Subtitle
            Positioned(
              left: 108,
              top: 582,
              child: Text(
                'Smart Transportation Platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF6B7280),
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
