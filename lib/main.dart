import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("اختبار Firebase")),
        body: const Center(child: FirebaseCheckWidget()),
      ),
    );
  }
}

class FirebaseCheckWidget extends StatefulWidget {
  const FirebaseCheckWidget({super.key});

  @override
  State<FirebaseCheckWidget> createState() => _FirebaseCheckWidgetState();
}

class _FirebaseCheckWidgetState extends State<FirebaseCheckWidget> {
  late Future<FirebaseApp> _firebaseApp;

  @override
  void initState() {
    super.initState();
    _firebaseApp = _initFirebase();
  }

  Future<FirebaseApp> _initFirebase() async {
    try {
      // إذا كان Firebase موجود مسبقاً يرجع الـ default instance
      return Firebase.apps.isEmpty
          ? await Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            )
          : Firebase.apps.first;
    } catch (e) {
      // أي خطأ يرجع الـ default instance
      return Firebase.apps.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: _firebaseApp,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(
            "جارٍ اختبار الاتصال بـ Firebase...",
            style: TextStyle(fontSize: 20, color: Colors.orange),
            textAlign: TextAlign.center,
          );
        } else if (snapshot.hasError) {
          return Text(
            "❌ فشل الاتصال: ${snapshot.error}",
            style: const TextStyle(fontSize: 20, color: Colors.red),
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            "✅ Firebase متصل بنجاح!",
            style: TextStyle(fontSize: 20, color: Colors.green),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
