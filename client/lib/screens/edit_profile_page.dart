// lib/screens/edit_profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final User currentUser;
  const EditProfilePage({super.key, required this.currentUser});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _nimController;
  late TextEditingController _emailController;
  File? _newProfileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.name);
    _nimController = TextEditingController(text: widget.currentUser.nim);
    _emailController = TextEditingController(text: widget.currentUser.email);
  }
  
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final response = await ApiService.instance.updateProfile(
        {
          'name': _nameController.text,
          'nim': _nimController.text,
          'email': _emailController.text,
        },
        _newProfileImage?.path,
      );

      if (mounted) {
        // Update data user di AuthProvider
        Provider.of<AuthProvider>(context, listen: false).updateUserData(response.data['user']);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profil berhasil diperbarui!'), backgroundColor: Colors.green));
        Navigator.of(context).pop(); // Kembali ke halaman view profil
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memperbarui profil: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profil')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _newProfileImage != null
                      ? FileImage(_newProfileImage!)
                      : (widget.currentUser.fotoProfilUrl != null ? NetworkImage(widget.currentUser.fotoProfilUrl!) : null) as ImageProvider?,
                    child: _newProfileImage == null && widget.currentUser.fotoProfilUrl == null ? const Icon(Icons.person, size: 60) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
            const SizedBox(height: 16),
            TextFormField(controller: _nimController, decoration: const InputDecoration(labelText: 'NIM')),
            const SizedBox(height: 16),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SIMPAN PERUBAHAN'),
            )
          ],
        ),
      ),
    );
  }
}