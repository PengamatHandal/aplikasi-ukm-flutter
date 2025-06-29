// lib/screens/ukm_detail_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/models/ukm.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/services/api_service.dart';
import 'package:dio/dio.dart';

class UkmDetailPage extends StatefulWidget {
  final int ukmId;
  const UkmDetailPage({super.key, required this.ukmId});

  @override
  State<UkmDetailPage> createState() => _UkmDetailPageState();
}

class _UkmDetailPageState extends State<UkmDetailPage> {
  late Future<Ukm> _ukmDetailFuture;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _ukmDetailFuture = _fetchUkmDetail();
  }

  Future<Ukm> _fetchUkmDetail() async {
    try {
      final response = await ApiService.instance.getUkmDetail(widget.ukmId);
      final ukmData = response.data;
      return Ukm.fromJson(ukmData);
    } catch (e) {
      throw Exception('Gagal memuat detail UKM: $e');
    }
  }

  Future<void> _handleDaftarUkm() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login terlebih dahulu untuk mendaftar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    setState(() => _isRegistering = true);
    
    try {
      await ApiService.instance.daftarUkm(widget.ukmId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Mohon tunggu konfirmasi.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan tidak dikenal.';
      
      // ERROR CHECKING
      print("--- DIO ERROR ---");
      print("Status Code: ${e.response?.statusCode}");
      print("Response Data: ${e.response?.data}");
      print("--- END DIO ERROR ---");
      
      if (e.response != null) {
          errorMessage = e.response?.data['message'] ?? 'Gagal mendaftar.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRegistering = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail UKM')),
      body: FutureBuilder<Ukm>(
        future: _ukmDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat detail: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Data UKM tidak ditemukan.'));
          }

          final ukm = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: ukm.logoUrl != null ? NetworkImage(ukm.logoUrl!) : null,
                    child: ukm.logoUrl == null ? const Icon(Icons.groups, size: 50) : null,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    ukm.namaUkm,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Chip(
                    label: Text(ukm.kategori ?? 'Tanpa Kategori'),
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Deskripsi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // PERBAIKAN DI SINI
                Text(
                  ukm.deskripsi ?? 'Tidak ada deskripsi yang tersedia.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                if (ukm.isPendaftaranBuka)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.person_add),
                      label: _isRegistering
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text('DAFTAR SEKARANG'),
                      onPressed: _isRegistering ? null : _handleDaftarUkm,
                    ),
                  )
                else
                  const Center(
                    child: Chip(
                      label: Text('Pendaftaran Ditutup'),
                      backgroundColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}