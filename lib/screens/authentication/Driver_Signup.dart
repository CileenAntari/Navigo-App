import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import 'OtpVerificationScreen.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _carNumberController = TextEditingController();

  String? _selectedRoute;
  String? _selectedCarType;

  static const List<String> _routes = ["Ramallah - Birzeit"];
  static const List<String> _carTypes = ["Bus", "Mini Bus", "Van"];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _carNumberController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    String phoneNumber = _phoneController.text.trim();
    String fullName = _nameController.text.trim();

    if (_selectedRoute == null || _selectedCarType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select route and car type")),
      );
      return;
    }

    // Send OTP
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (verificationId, resendToken) {
        if (!mounted) return;

        // Navigate to OTP screen with role and driver data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              phoneNumber: phoneNumber,
              verificationId: verificationId,
              fullName: fullName,
              role: "driver", // specify role here
              driverData: {
                "vehicle": _selectedCarType!,
                "route": _selectedRoute!,
                "licenseNumber": _carNumberController.text.trim(),
                "availability": true,
              },
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NavigoColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              NavigoDecorations.topBar(onBack: () => Navigator.pop(context)),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Driver details",
                      style: NavigoTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    _label("Full Name"),
                    _inputField(
                      controller: _nameController,
                      hint: "Ahmad Saleh",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),
                    _label("Phone"),
                    _inputField(
                      controller: _phoneController,
                      hint: "+97059 000 0000",
                      keyboard: TextInputType.phone,
                      prefixIcon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 16),
                    _label("Working line / route"),
                    _dropdownField(
                      value: _selectedRoute,
                      hint: "Select line",
                      items: _routes,
                      onChanged: (val) => setState(() => _selectedRoute = val),
                    ),
                    const SizedBox(height: 16),
                    _label("Car number (plate)"),
                    _inputField(
                      controller: _carNumberController,
                      hint: "7-1234",
                      prefixIcon: Icons.confirmation_number_outlined,
                    ),
                    const SizedBox(height: 16),
                    _label("Car type"),
                    _dropdownField(
                      value: _selectedCarType,
                      hint: "Select car type",
                      items: _carTypes,
                      onChanged: (val) =>
                          setState(() => _selectedCarType = val),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: NavigoDecorations.kPrimaryButtonLargeStyle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("Submit", style: NavigoTextStyles.button),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "Your account may require approval.",
                        style: NavigoTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text, style: NavigoTextStyles.label),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
      decoration: NavigoDecorations.kInputDecoration.copyWith(
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Colors.green)
            : null,
        suffixIcon: prefixIcon != null
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => controller.clear(),
              )
            : null,
      ),
    );
  }

  Widget _dropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: const TextStyle(color: Colors.black, fontSize: 16),
      hint: Text(hint, style: const TextStyle(color: Colors.grey)),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(color: Colors.black)),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? "Required" : null,
      decoration: NavigoDecorations.kInputDecoration,
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}
