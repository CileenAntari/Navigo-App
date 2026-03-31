import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../theme/app_theme.dart';
import '../passenger/PassengerBottomNavBar.dart';
import '../passenger/support_screen.dart';
import '../passenger/PassengerHomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isEditing = false;

  User? currentUser;
  late DocumentReference userDocRef;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      userDocRef = FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot snapshot = await userDocRef.get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        _nameController.text = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";
        _phoneController.text = data['phone'] ?? '';
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _saveProfile() async {
    if (currentUser == null) return;

    setState(() => _isEditing = false);

    // Split first and last name
    List<String> names = _nameController.text.trim().split(" ");
    String firstName = names.isNotEmpty ? names[0] : "";
    String lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

    try {
      await userDocRef.update({
        "firstName": firstName,
        "lastName": lastName,
        "phone": _phoneController.text.trim(),
        // If you implement image upload, include a field "image": downloadUrl
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const PassengerBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            /// TOP BAR
            NavigoDecorations.topBar(
              onBack: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const PassengerHomeScreen()),
              ),
            ),

            /// TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Profile", style: NavigoTextStyles.titleLarge),
                  IconButton(
                    onPressed: _toggleEdit,
                    icon: Icon(
                      _isEditing ? Icons.close : Icons.edit,
                      color: NavigoColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: NavigoDecorations.kCardDecoration,
                  child: Column(
                    children: [
                      /// PROFILE IMAGE
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage("assets/images/logo.png")
                                    as ImageProvider,
                          ),
                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImagePicker,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: NavigoColors.primaryOrange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// NAME
                      _field(
                        "Full Name",
                        _nameController,
                        _isEditing,
                        Icons.person,
                      ),

                      const SizedBox(height: 16),

                      /// PHONE
                      _field(
                        "Phone",
                        _phoneController,
                        _isEditing,
                        Icons.phone,
                      ),

                      const SizedBox(height: 20),

                      /// SAVE BUTTON
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style: NavigoDecorations.kPrimaryButtonLargeStyle,
                            child: const Text("Save"),
                          ),
                        ),

                      const SizedBox(height: 20),

                      /// SETTINGS
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Settings",
                          style: NavigoTextStyles.titleSmall.copyWith(
                            color: NavigoColors.textGray,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      _settingsItem(
                        icon: Icons.help_outline,
                        title: "Help & Support",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HelpSupportScreen(),
                            ),
                          );
                        },
                      ),

                      _settingsItem(
                        icon: Icons.logout,
                        title: "Log out",
                        color: Colors.red,
                        onTap: _logout,
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

  /// FIELD
  Widget _field(
    String label,
    TextEditingController controller,
    bool enabled,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: NavigoTextStyles.label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          style: const TextStyle(
            color: NavigoColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: NavigoDecorations.kInputDecoration.copyWith(
            prefixIcon: Icon(icon, color: NavigoColors.primaryOrange),
          ),
        ),
      ],
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: color),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}