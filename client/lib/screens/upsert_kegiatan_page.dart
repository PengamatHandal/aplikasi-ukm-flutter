// lib/screens/upsert_kegiatan_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:client/models/kegiatan.dart';
import 'package:client/services/api_service.dart';
import 'package:dio/dio.dart';

class UpsertKegiatanPage extends StatefulWidget {
  final Kegiatan? kegiatan;
  const UpsertKegiatanPage({super.key, this.kegiatan});

  @override
  State<UpsertKegiatanPage> createState() => _UpsertKegiatanPageState();
}

class _UpsertKegiatanPageState extends State<UpsertKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  bool get _isEditing => widget.kegiatan != null;
  bool _isLoading = false;

  late TextEditingController _judulController;
  late TextEditingController _deskripsiController;
  late TextEditingController _lokasiController;
  DateTime? _selectedDate;
  File? _imageFile;
  String? _existingImageUrl;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.kegiatan?.judul ?? '');
    _deskripsiController = TextEditingController(text: widget.kegiatan?.deskripsi ?? '');
    _lokasiController = TextEditingController(text: widget.kegiatan?.lokasi ?? '');
    _selectedDate = widget.kegiatan?.tanggalAcara;
    _existingImageUrl = widget.kegiatan?.gambarUrl;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tanggal acara wajib diisi!'), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Siapkan data form
      final formData = FormData.fromMap({
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'lokasi': _lokasiController.text,
        'tanggal_acara': _selectedDate!.toIso8601String(),
      });
      
      // Tambahkan file gambar jika ada yang baru dipilih
      if (_imageFile != null) {
        formData.files.add(MapEntry('gambar', await MultipartFile.fromFile(_imageFile!.path)));
      }

      // Tentukan apakah akan create atau update
      if (_isEditing) {
        // Laravel menangani PUT/PATCH via POST dengan field _method
        formData.fields.add(const MapEntry('_method', 'POST'));
        await ApiService.instance.updateKegiatan(widget.kegiatan!.id, formData);
      } else {
        await ApiService.instance.createKegiatan(formData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kegiatan berhasil disimpan!'), backgroundColor: Colors.green));
        Navigator.of(context).pop(true); // Kirim 'true' untuk menandakan ada perubahan
      }

    } on DioException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${e.response?.data['message'] ?? 'Gagal menyimpan'}'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Kegiatan' : 'Buat Kegiatan Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Image Picker
            _buildImagePicker(),
            const SizedBox(height: 24),
            // Form Fields
            TextFormField(controller: _judulController, decoration: const InputDecoration(labelText: 'Judul Kegiatan'), validator: (v) => v!.isEmpty ? 'Judul wajib diisi' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi'), maxLines: 5, validator: (v) => v!.isEmpty ? 'Deskripsi wajib diisi' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _lokasiController, decoration: const InputDecoration(labelText: 'Lokasi'), validator: (v) => v!.isEmpty ? 'Lokasi wajib diisi' : null),
            const SizedBox(height: 16),
            // Date Time Picker
            ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade400)),
              leading: const Icon(Icons.calendar_month),
              title: const Text('Tanggal Acara'),
              subtitle: Text(_selectedDate == null ? 'Pilih tanggal & waktu' : DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(_selectedDate!)),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 32),
            // Tombol Submit
            FilledButton.icon(
              icon: _isLoading ? Container() : Icon(_isEditing ? Icons.save : Icons.add),
              label: _isLoading
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                : Text(_isEditing ? 'SIMPAN PERUBAHAN' : 'BUAT KEGIATAN'),
              onPressed: _isLoading ? null : _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    ImageProvider? imageProvider;
    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!);
    } else if (_existingImageUrl != null) {
      imageProvider = NetworkImage(_existingImageUrl!);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              image: imageProvider != null ? DecorationImage(image: imageProvider, fit: BoxFit.cover) : null,
            ),
            child: imageProvider == null ? const Center(child: Icon(Icons.image, size: 60, color: Colors.grey)) : null,
          ),
          Positioned(
            bottom: 8, right: 8,
            child: FloatingActionButton.small(
              onPressed: _pickImage,
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}