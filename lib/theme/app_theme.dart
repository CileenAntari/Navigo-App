import 'package:flutter/material.dart';

class NavigoColors {
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color primaryAmber = Color(0xFFF59E0B);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundAlt = Color(0xFFF9F8F4);
  static const Color cardLight = Color(0xFFFAFAFA);
  static const Color inputFill = Color(0xFFF7F7F7);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textGray = Colors.black54;
  static const Color shadowColor = Colors.black12;
  static const Color accentGreen = Colors.green;
  static const Color lightorange = Color.fromARGB(255, 247, 241, 234);
}

class NavigoTextStyles {
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: NavigoColors.textDark,
  );
  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13,
    color: NavigoColors.textGray,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: NavigoColors.textGray,
  );
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static const TextStyle buttonOrangeLink = TextStyle(
    fontSize: 16,
    color: NavigoColors.primaryOrange,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  );
}

class NavigoDecorations {
  static Widget topBar({required VoidCallback onBack}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: kTopBarBackButton,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: onBack,
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain, // مهم حتى تظهر الصورة كاملة
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final BoxDecoration kCardDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 247, 241, 234),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    border: Border.all(color: NavigoColors.primaryOrange, width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        offset: const Offset(0, 2),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );

  static final BoxDecoration kLightCardDecoration = BoxDecoration(
    color: const Color.fromARGB(255, 247, 241, 234),
    borderRadius: const BorderRadius.all(Radius.circular(20)),
    border: Border.all(color: NavigoColors.primaryOrange, width: 1.2),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        offset: const Offset(0, 2),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
  );

  static BoxDecoration kTopBarBackButton = BoxDecoration(
    shape: BoxShape.circle,
    border: Border.fromBorderSide(BorderSide(color: Colors.grey.shade300)),
  );

  static InputDecoration kInputDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: NavigoColors.inputFill,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: NavigoColors.primaryOrange, width: 2),
    ),
  );

  static ButtonStyle kPrimaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: NavigoColors.primaryOrange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 15),
    elevation: 0,
  );

  static ButtonStyle kPrimaryButtonLargeStyle = ElevatedButton.styleFrom(
    backgroundColor: NavigoColors.primaryOrange,
    foregroundColor: Colors.white, // ← This makes text white
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    elevation: 0,
  );

  static ButtonStyle kAmberButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: NavigoColors.primaryAmber,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  );

  static ButtonStyle kRoleButtonStyle = OutlinedButton.styleFrom(
    side: BorderSide(color: NavigoColors.primaryOrange, width: 2),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
  );
}

ThemeData get appTheme {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: NavigoColors.primaryOrange,
      brightness: Brightness.light,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: NavigoColors.backgroundLight,
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      elevation: 4,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      filled: true,
      fillColor: NavigoColors.inputFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: NavigoColors.primaryOrange, width: 2),
      ),
      hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: NavigoDecorations.kPrimaryButtonStyle.copyWith(
        textStyle: WidgetStateProperty.all(NavigoTextStyles.button),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: NavigoTextStyles.titleLarge,
      headlineMedium: NavigoTextStyles.titleMedium,
      titleLarge: NavigoTextStyles.titleSmall,
      bodySmall: NavigoTextStyles.bodySmall,
      bodyMedium: NavigoTextStyles.bodyMedium,
      labelLarge: NavigoTextStyles.label,
    ),
  );
}
