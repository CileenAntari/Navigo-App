import 'package:flutter/material.dart';
import 'package:navigo/screens/authentication/SignupApproval.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({Key? key}) : super(key: key);

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

  // ✅ Const Lists
  static const List<String> _routes = [
    "Ramallah - Birzeit",
  ];

  static const List<String> _carTypes = [
    "Bus",
    "Mini Bus",
    "Van",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _carNumberController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "route": _selectedRoute,
      "carNumber": _carNumberController.text.trim(),
      "carType": _selectedCarType,
    };

    print(data);

    // TODO: Send to Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const CircleAvatar(radius: 18),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form Card
            Expanded(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Driver details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Full Name
                        _label("Full name"),
                        _inputField(
                          controller: _nameController,
                          hint: "e.g., Ahmad Saleh",
                        ),

                        const SizedBox(height: 16),

                        // Phone
                        _label("Phone number"),
                        _inputField(
                          controller: _phoneController,
                          hint: "059 000 0000",
                          keyboard: TextInputType.phone,
                        ),

                        const SizedBox(height: 16),

                        // Route Dropdown
                        _label("Working line / route"),
                        _dropdownField(
                          value: _selectedRoute,
                          hint: "Select line",
                          items: _routes,
                          onChanged: (val) {
                            setState(() => _selectedRoute = val);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Car Number
                        _label("Car number (plate)"),
                        _inputField(
                          controller: _carNumberController,
                          hint: "e.g., 7-1234",
                        ),

                        const SizedBox(height: 16),

                        // Car Type Dropdown
                        _label("Car type"),
                        _dropdownField(
                          value: _selectedCarType,
                          hint: "Select car type",
                          items: _carTypes,
                          onChanged: (val) {
                            setState(() => _selectedCarType = val);
                          },
                        ),

                        const Spacer(),

                        // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const SignupApprovalScreen(),
                          ),
                        );
                      },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFFF9800),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                          
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
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

  // 🔹 Helpers

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style:
            const TextStyle(fontSize: 13, color: Colors.black54),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (value) =>
          value == null || value.isEmpty ? "Required" : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
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
      value: value,
      hint: Text(hint),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null ? "Required" : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
    );
  }
}