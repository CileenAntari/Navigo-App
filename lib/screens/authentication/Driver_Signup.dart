import 'package:flutter/material.dart';
import 'package:navigo/screens/authentication/SignupApproval.dart';
import '../../theme/app_theme.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupApprovalScreen()),
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

            /// Centered Form Card
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: NavigoDecorations.kCardDecoration,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Driver details",
                              style: NavigoTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 20),

                            /// Full Name
                            _label("Full name"),
                            _inputField(
                              controller: _nameController,
                              hint: "e.g., Ahmad Saleh",
                              prefixIcon: Icons.person_outline,
                            ),
                            const SizedBox(height: 16),

                            /// Phone
                            _label("Phone number"),
                            _inputField(
                              controller: _phoneController,
                              hint: "+97059 000 0000",
                              keyboard: TextInputType.phone,
                              prefixIcon: Icons.phone_outlined,
                            ),
                            const SizedBox(height: 16),

                            /// Route
                            _label("Working line / route"),
                            _dropdownField(
                              value: _selectedRoute,
                              hint: "Select line",
                              items: _routes,
                              onChanged: (val) =>
                                  setState(() => _selectedRoute = val),
                            ),
                            const SizedBox(height: 16),

                            /// Car Number
                            _label("Car number (plate)"),
                            _inputField(
                              controller: _carNumberController,
                              hint: "e.g., 7-1234",
                              prefixIcon: Icons.confirmation_number_outlined,
                            ),
                            const SizedBox(height: 16),

                            /// Car Type
                            _label("Car type"),
                            _dropdownField(
                              value: _selectedCarType,
                              hint: "Select car type",
                              items: _carTypes,
                              onChanged: (val) =>
                                  setState(() => _selectedCarType = val),
                            ),
                            const SizedBox(height: 25),

                            /// Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                onPressed: _submit,
                                style:
                                    NavigoDecorations.kPrimaryButtonLargeStyle,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "Submit",
                                      style: NavigoTextStyles.button,
                                    ),
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

  /// Label Widget
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: NavigoTextStyles.label),
    );
  }

  /// Input Field Widget
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      // ← Forces black text in the text field
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

  /// Dropdown Widget
  Widget _dropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      // ← Forces black text for the selected value in the dropdown
      style: const TextStyle(color: Colors.black, fontSize: 16),
      hint: Text(hint, style: TextStyle(color: Colors.grey)),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              // ← Forces black text for each item in the dropdown list
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
