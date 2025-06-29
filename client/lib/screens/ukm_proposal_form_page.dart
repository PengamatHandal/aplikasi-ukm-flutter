// lib/screens/ukm_proposal_form_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:client/services/api_service.dart'; 
import 'package:dio/dio.dart';

class UkmProposalFormPage extends StatefulWidget {
  const UkmProposalFormPage({super.key});

  @override
  State<UkmProposalFormPage> createState() => _UkmProposalFormPageState();
}

class _UkmProposalFormPageState extends State<UkmProposalFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _kategoriController = TextEditingController();

  File? _logoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _kategoriController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitProposal() async {
    if (!_formKey.currentState!.validate() || _logoFile == null) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua field dan logo wajib diisi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.instance.submitUkmProposal({
        'nama_ukm': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'kategori': _kategoriController.text,
      }, 
      _logoFile!.path, 
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposal berhasil diajukan! Mohon tunggu review.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); 
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan.';
      if (e.response?.statusCode == 422) { 
        errorMessage = 'Data tidak valid. Pastikan nama UKM belum pernah ada atau diajukan.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul diubah
        title: const Text('Ajukan Proposal UKM'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _logoFile != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(_logoFile!, fit: BoxFit.cover),
                          )
                          : const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Pilih Logo UKM'),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama UKM yang Diajukan', border: OutlineInputBorder(), prefixIcon: Icon(Icons.groups)),
                validator: (value) => value == null || value.isEmpty ? 'Nama UKM tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi Singkat', border: OutlineInputBorder(), prefixIcon: Icon(Icons.description)),
                maxLines: 5,
                validator: (value) => value == null || value.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori (Contoh: Olahraga, Seni)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.category)),
                validator: (value) => value == null || value.isEmpty ? 'Kategori tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                icon: const Icon(Icons.send),
                label: _isLoading
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                    : const Text('AJUKAN PROPOSAL'),
                onPressed: _isLoading ? null : _submitProposal,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}