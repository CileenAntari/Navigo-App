import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../passenger/PassengerBottomNavBar.dart';
import '../passenger/support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Lara Shaltaf");
  final TextEditingController _phoneController =
      TextEditingController(text: "+970591234567");

  final ImagePicker _picker = ImagePicker();
  File? _image;

  bool _isEditing = false;

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  /// 🔹 Pick from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  /// 🔹 Show bottom sheet
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

  void _logout() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _saveProfile() {
    setState(() => _isEditing = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated")),
    );

    // TODO: upload image + save to Firebase
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar:
          const PassengerBottomNavBar(currentIndex: 3),

      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Profile",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: _toggleEdit,
                    icon: Icon(
                        _isEditing ? Icons.close : Icons.edit),
                  )
                ],
              ),
            ),

            /// Body
            Expanded(
              child: SingleChildScrollView(
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
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      /// PROFILE IMAGE
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : const AssetImage(
                                        "assets/images/logo.png")
                                    as ImageProvider,
                          ),

                          if (_isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImagePicker,
                                child: Container(
                                  padding:
                                      const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// NAME
                      _field("Full Name", _nameController,
                          _isEditing, Icons.person),

                      const SizedBox(height: 16),

                      /// PHONE
                      _field("Phone", _phoneController,
                          _isEditing, Icons.phone),

                      const SizedBox(height: 20),

                      /// SAVE BUTTON
                      if (_isEditing)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveProfile,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFFF9800),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text("Save"),
                          ),
                        ),

                      const SizedBox(height: 20),

                      /// SETTINGS
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
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
                              builder: (_) =>
                                  const HelpSupportScreen(),
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

  /// Reusable field
  Widget _field(String label, TextEditingController controller,
      bool enabled, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
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
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: color)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}