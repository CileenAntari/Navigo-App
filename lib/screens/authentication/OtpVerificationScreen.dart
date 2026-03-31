import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../passenger/passengerHomeScreen.dart';
import '../../models/driver.dart';
import 'SignupApproval.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

 final String? fullName;
final String? role;
  final Map<String, dynamic>? driverData;


  const OtpVerificationScreen({
  super.key,
  required this.phoneNumber,
  required this.verificationId,
  this.fullName,
  this.role,
  this.driverData, // ✅ add here

});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onContinue() async {
  String otp = _otpControllers.map((e) => e.text).join();

  if (otp.length != 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enter a valid 6-digit OTP")),
    );
    return;
  }

  try {
    // ✅ Verify OTP
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    String uid = userCredential.user!.uid;

    // ✅ Split full name safely
    String firstName = "";
    String lastName = "";
    if (widget.fullName != null && widget.fullName!.isNotEmpty) {
      List<String> names = widget.fullName!.split(" ");
      firstName = names.isNotEmpty ? names[0] : "";
      lastName = names.length > 1 ? names[1] : "";
    }

    // ✅ Save user data in 'users' collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({
          "userId": uid,
          "firstName": firstName,
          "lastName": lastName,
          "phone": widget.phoneNumber,
          "image": null,
          "role": widget.role ?? "passenger",
          "isVerified": true,
        }, SetOptions(merge: true));

    // ✅ Role-specific collections
    if (widget.role == "passenger") {
      await FirebaseFirestore.instance
          .collection('passengers')
          .doc(uid)
          .set({
        "tripHistory": [],
        "paymentMethods": [],
      }, SetOptions(merge: true));
      // Navigate to passenger home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PassengerHomeScreen(),
        ),
      );
    } else if (widget.role == "driver" && widget.driverData != null) {
      // Create DriverModel object
      final driver = DriverModel(
        userId: uid,
        firstName: firstName,
        lastName: lastName,
        phone: widget.phoneNumber,
        image: null,
        role: "driver",
        isVerified: true,
        vehicle: widget.driverData!['vehicle'] ?? '',
        route: widget.driverData!['route'] ?? '',
        availability: widget.driverData!['availability'] ?? true,
        licenseNumber: widget.driverData!['licenseNumber'] ?? '',
      );

      // Save to 'drivers' collection
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(uid)
          .set(driver.toMap(), SetOptions(merge: true));

      // Navigate to driver home (replace with your DriverHomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const SignupApprovalScreen(), // TODO: Replace with DriverHomeScreen
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid OTP: $e")),
    );
  }
}
  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Resend not implemented yet")),
    );
  }

  Widget _buildOtpTextField(int index) {
    return SizedBox(
      width: 52,
      height: 62,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: NavigoColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: NavigoColors.primaryOrange.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: NavigoColors.primaryOrange,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundAlt,
      body: SafeArea(
        child: Column(
          children: [
            NavigoDecorations.topBar(onBack: () => Navigator.pop(context)),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 24,
                      ),
                      decoration: NavigoDecorations.kCardDecoration,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Verify phone number",
                            style: NavigoTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter the 6-digit code sent to ${widget.phoneNumber}",
                            textAlign: TextAlign.center,
                            style: NavigoTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => _buildOtpTextField(index),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive SMS? ",
                                style: NavigoTextStyles.bodySmall,
                              ),
                              GestureDetector(
                                onTap: _resendCode,
                                child: const Text(
                                  "Resend Code",
                                  style: NavigoTextStyles.buttonOrangeLink,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _onContinue,
                              style:
                                  NavigoDecorations.kPrimaryButtonLargeStyle,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text("Continue",
                                      style: NavigoTextStyles.button),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            "note: OTP expires in 2 minutes.",
                            style: NavigoTextStyles.bodySmall,
                          ),

                          const SizedBox(height: 12),

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              "Change phone number",
                              style: TextStyle(
                                color: NavigoColors.accentGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
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
          ],
        ),
      ),
    );
  }
}