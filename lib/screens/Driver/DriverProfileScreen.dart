import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../theme/app_theme.dart';
import 'DriverBottomNavBar.dart';
import '../../screens/passenger/support_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  State<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _image;
  String? _imageUrl;

  bool _isEditing = false;
  bool _isOnline = true;
  bool _isLoading = true;
  bool _isSaving = false;

  User? currentUser;
  DocumentReference<Map<String, dynamic>>? userDocRef;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid);
      _loadUserData();
    } else {
      _isLoading = false;
    }
  }

  Future<void> _loadUserData() async {
    if (userDocRef == null) return;

    try {
      final snapshot = await userDocRef!.get();

      if (snapshot.exists) {
        final data = snapshot.data() ?? {};

        _nameController.text =
            "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}".trim();

        _phoneController.text = data['phone'] ?? '';
        _isOnline = data['isOnline'] ?? true;
        _imageUrl = data['image'];
      }
    } catch (e) {
      debugPrint("Error loading driver data: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to load profile: $e")));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 75);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
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

  Future<String?> _uploadProfileImage() async {
    if (_image == null || currentUser == null) return _imageUrl;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${currentUser!.uid}.jpg');

      await storageRef.putFile(_image!);
      final downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      debugPrint("Image upload error: $e");
      rethrow;
    }
  }

  Future<void> _saveProfile() async {
    if (currentUser == null || userDocRef == null) return;

    setState(() {
      _isSaving = true;
    });

    final names = _nameController.text.trim().split(" ");
    final firstName = names.isNotEmpty ? names.first : "";
    final lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

    try {
      final uploadedImageUrl = await _uploadProfileImage();

      await userDocRef!.update({
        "firstName": firstName,
        "lastName": lastName,
        "phone": _phoneController.text.trim(),
        "image": uploadedImageUrl,
      });

      if (mounted) {
        setState(() {
          _imageUrl = uploadedImageUrl;
          _isEditing = false;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Profile updated")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _toggleDriverStatus() async {
    if (userDocRef == null) return;

    final newStatus = !_isOnline;

    try {
      await userDocRef!.update({"isOnline": newStatus});

      if (mounted) {
        setState(() => _isOnline = newStatus);
      }
    } catch (e) {
      debugPrint("Failed to update online status: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update status: $e")));
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  ImageProvider _buildProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return NetworkImage(_imageUrl!);
    } else {
      return const AssetImage("assets/images/logo.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const DriverBottomNavBar(currentIndex: 3),
      body: SafeArea(
        child: Column(
          children: [
            NavigoDecorations.topBar(onBack: () => Navigator.pop(context)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Driver Profile",
                    style: NavigoTextStyles.titleLarge,
                  ),
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
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(20),
                        decoration: NavigoDecorations.kCardDecoration,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _buildProfileImage(),
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
                            _field(
                              "Full Name",
                              _nameController,
                              _isEditing,
                              Icons.person,
                            ),
                            const SizedBox(height: 16),
                            _field(
                              "Phone",
                              _phoneController,
                              _isEditing,
                              Icons.phone,
                            ),
                            const SizedBox(height: 20),
                            if (_isEditing)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveProfile,
                                  style: NavigoDecorations
                                      .kPrimaryButtonLargeStyle,
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text("Save"),
                                ),
                              ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _toggleDriverStatus,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isOnline
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                                child: Text(
                                  _isOnline
                                      ? "Switch to Offline"
                                      : "Switch to Online",
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
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
