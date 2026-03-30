import 'package:flutter/material.dart';
import 'package:navigo/screens/authentication/PhoneNumberScreen.dart';
import '../../theme/app_theme.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                            "Route Manager Login",
                            style: NavigoTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Sign in using your administrator email and password.",
                            style: NavigoTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 10),

                          /// Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Route Manager only",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          /// Email Field
                          const Text("Email", style: NavigoTextStyles.label),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            decoration: NavigoDecorations.kInputDecoration
                                .copyWith(
                                  hintText: "RouteManager@navigo.com",
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Colors.green,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => _emailController.clear(),
                                  ),
                                ),
                          ),
                          const SizedBox(height: 16),

                          /// Password Field
                          const Text("Password", style: NavigoTextStyles.label),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: NavigoDecorations.kInputDecoration
                                .copyWith(
                                  prefixIcon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.green,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                          ),
                          const SizedBox(height: 25),

                          /// Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: NavigoDecorations.kPrimaryButtonLargeStyle,
                              onPressed: () {
                                // TODO: Add sign-in logic
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Sign In",
                                    style: NavigoTextStyles.button,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          /// Back to user login
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PhoneNumberScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Back to user login",
                                style: NavigoTextStyles.buttonOrangeLink,
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
