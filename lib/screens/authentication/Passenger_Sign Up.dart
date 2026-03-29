import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OtpVerificationScreen.dart';

class PassengerSignupScreen extends StatefulWidget {
  const PassengerSignupScreen({Key? key}) : super(key: key);

  @override
  State<PassengerSignupScreen> createState() =>
      _PassengerSignupScreenState();
}

class _PassengerSignupScreenState extends State<PassengerSignupScreen> {
  bool _agreeToTerms = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        AssetImage('assets/images/logo.png'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card
            Expanded(
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Passenger details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Name
                      const Text(
                        "Full name",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nameController,
                        hint: "e.g., Cileen antari",
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 16),

                      // Phone
                      const Text(
                        "Phone number",
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _phoneController,
                        hint: "059 000 0000",
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),

                      // Terms + Button together
                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _agreeToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms =
                                        value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black),
                                    children: [
                                      const TextSpan(
                                          text: "I agree to "),
                                      TextSpan(
                                        text: "Terms",
                                        style:
                                            const TextStyle(
                                          color: Colors.orange,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {},
                                      ),
                                      const TextSpan(
                                          text: " & "),
                                      TextSpan(
                                        text: "Privacy",
                                        style:
                                            const TextStyle(
                                          color: Colors.orange,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                        recognizer:
                                            TapGestureRecognizer()
                                              ..onTap = () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Button directly under checkbox
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _agreeToTerms
                                  ? _submit
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFFF9800),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          30),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  void _submit() async {
  final name = _nameController.text.trim();
  final phone = _phoneController.text.trim();

  if (name.isEmpty || phone.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  if (!_agreeToTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You must agree to the terms")),
    );
    return;
  }

  final formattedPhone = _formatPhoneNumber(phone);

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: formattedPhone,
    timeout: const Duration(seconds: 60),

    verificationCompleted: (PhoneAuthCredential credential) async {
      await FirebaseAuth.instance.signInWithCredential(credential);
    },

    verificationFailed: (FirebaseAuthException e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    },

    codeSent: (String verificationId, int? resendToken) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: formattedPhone,
            verificationId: verificationId,
          ),
        ),
      );
    },

    codeAutoRetrievalTimeout: (String verificationId) {},
  );
}
}
String _formatPhoneNumber(String phone) {
  String cleaned = phone.replaceAll(RegExp(r'\s+'), '');

  // Already in international format
  if (cleaned.startsWith('+')) return cleaned;

  // Local Palestinian number (starts with 0)
  if (cleaned.startsWith('0')) {
    return '+970${cleaned.substring(1)}';
  }

  // If user entered without 0 (e.g. 59xxxxxxx)
  if (cleaned.startsWith('5')) {
    return '+970$cleaned';
  }

  // fallback
  return cleaned;
}
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
