import 'package:flutter/material.dart';
import 'screens/welcome_flow/role.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildIllustrationSection(),
                    _buildContentSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          Image.asset(
            'images/welcome.png',
            width: 260,
            height: 260,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          const Text(
            'Browse routes, track vehicles, and request trips.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              height: 1.4,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(height: 28),

          /// Get Started Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_right_alt),
              label: const Text('Get Started'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () => _onGetStartedPressed(context),
            ),
          ),

          const SizedBox(height: 16),

          /// Sign In Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(),
              onPressed: () => _onSignInPressed(context),
              child: const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 11, 93, 46),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onGetStartedPressed(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
    );
  }

  void _onSignInPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign in is not yet implemented.')),
    );
  }
}
