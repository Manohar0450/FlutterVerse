import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../utils/snackbar_helper.dart';
import '../utils/token_storage.dart';
import '../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _currentEmailController = TextEditingController();
  final _newEmailController = TextEditingController();

  XFile? _pickedImage;
  String? _imageUrl;
  bool _isCurrentEmailValid = true;
  bool _isNewEmailValid = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    _userId = await TokenStorage.getUserData();
    if (_userId == null) {
      showSnackBar(context, 'User not logged in', isError: true);
      return;
    }

    final response = await http.get(Uri.parse('$apiBaseUrl/auth/$_userId'));

    if (response.statusCode == 200) {
      final user = UserModel.fromJson(jsonDecode(response.body));
      setState(() {
        _nameController.text = user.username;
        _bioController.text = user.bio ?? '';
        _currentEmailController.text = user.email;
        _imageUrl = user.profilePicture;
      });
    } else {
      showSnackBar(context, 'Failed to load user details', isError: true);
    }
  }

  void _validateEmail(String value, bool isCurrent) {
    final isValid = value.isEmpty ||
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    setState(() {
      if (isCurrent) {
        _isCurrentEmailValid = isValid;
      } else {
        _isNewEmailValid = isValid;
      }
    });
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = picked);
      await _uploadImage(picked);
    }
  }

  Future<void> _uploadImage(XFile pickedImage) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/uploads/upload-profile'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', pickedImage.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      final data = jsonDecode(result);
      setState(() {
        _imageUrl = data['imageUrl'];
      });
      showSnackBar(context, 'Image uploaded successfully');
    } else {
      showSnackBar(context, 'Image upload failed', isError: true);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (_userId == null) {
      showSnackBar(context, 'User not logged in', isError: true);
      return;
    }

    final updated = await AuthService().updateUserProfile(
      userId: _userId!,
      username: _nameController.text.trim(),
      bio: _bioController.text.trim(),
      newEmail: _newEmailController.text.trim(),
      profilePicture: _imageUrl ?? '',
    );

    if (updated) {
      showSnackBar(context, 'Profile updated successfully');
      Navigator.pop(context);
    } else {
      showSnackBar(context, 'Failed to update profile', isError: true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _currentEmailController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F10),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F10),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('SAVE', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : null,
                    backgroundColor: Colors.white24,
                    child: _imageUrl == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white70)
                        : null,
                  ),
                  const Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField(_nameController, 'Full Name', validator: true),
            const SizedBox(height: 20),
            _buildTextField(_bioController, 'Bio', maxLines: 3),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Change Email:',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            _buildEmailField(
              controller: _currentEmailController,
              label: 'Current Email',
              isValid: _isCurrentEmailValid,
              onChanged: (val) => _validateEmail(val, true),
            ),
            if (!_isCurrentEmailValid)
              _errorText('Please enter a valid current email'),
            const SizedBox(height: 15),
            _buildEmailField(
              controller: _newEmailController,
              label: 'New Email',
              isValid: _isNewEmailValid,
              onChanged: (val) => _validateEmail(val, false),
            ),
            if (!_isNewEmailValid) _errorText('Please enter a valid new email'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Verify Email',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool validator = false, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: _inputDecoration(label),
      validator: validator
          ? (val) => val == null || val.trim().isEmpty ? 'Required' : null
          : null,
    );
  }

  Widget _buildEmailField({
    required TextEditingController controller,
    required String label,
    required bool isValid,
    required void Function(String) onChanged,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: onChanged,
      decoration: _inputDecoration(label).copyWith(
        prefixIcon: const Icon(Icons.email, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.white24 : Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isValid ? Colors.blueAccent : Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _errorText(String msg) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(msg, style: const TextStyle(color: Colors.red, fontSize: 12)),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white24),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
