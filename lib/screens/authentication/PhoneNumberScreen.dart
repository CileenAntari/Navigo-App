import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import 'OtpVerificationScreen.dart';
import 'email_login.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();

  // Optional: store full name & role if coming from signup
  String? fullName;
  String? role; // "passenger" or "driver"
  Map<String, dynamic>? driverData;

  void _sendOtp() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter a phone number")));
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto login (optional)
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
              fullName: fullName, // Pass full name if exists
              role: role, // Pass role if exists
              driverData: driverData, // Pass driver info if exists
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Bar
            NavigoDecorations.topBar(onBack: () => Navigator.pop(context)),

            /// Centered Body
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 450),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: NavigoDecorations.kCardDecoration,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Enter your phone number",
                              style: NavigoTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "We'll send you a one-time code (OTP) to verify your number.",
                              style: NavigoTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 20),

                            /// Phone Field
                            const Text(
                              "Phone number",
                              style: NavigoTextStyles.label,
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                              decoration: NavigoDecorations.kInputDecoration
                                  .copyWith(
                                hintText: "e.g. +97059 000 0000",
                                prefixIcon: const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.green,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () => _phoneController.clear(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),

                            /// Send OTP Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style:
                                    NavigoDecorations.kPrimaryButtonLargeStyle,
                                onPressed: _sendOtp,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Send Verification Code",
                                      style: NavigoTextStyles.button,
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            /// Email Login
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailLoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Sign in with email",
                                  style: NavigoTextStyles.button.copyWith(
                                    color: NavigoColors.accentGreen,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}