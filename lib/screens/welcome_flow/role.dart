import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  void _onRoleSelected(String role) {
    debugPrint('Selected role: $role');
  }

  void _onSignInTap() {
    debugPrint('Navigate to sign in');
  }

  Widget _buildRoleButton(
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE7F8F5),
          foregroundColor: Colors.black87,
          elevation: 1,
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Icon(
                Icons.person,
                size: 20.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create Your Account',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Choose your role to continue',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 32.0),
            Expanded(
              child: Column(
                children: [
                  _buildRoleButton(
                    'Passenger',
                    'Browse routes and request trips',
                    () => _onRoleSelected('passenger'),
                  ),
                  const SizedBox(height: 20.0),
                  _buildRoleButton(
                    'Driver',
                    'Accept trips and manage availability',
                    () => _onRoleSelected('driver'),
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 14.0, color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: _onSignInTap,
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
