// lib/screens/ukm_list_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/ukm.dart';
import 'package:client/screens/ukm_detail_page.dart';
import 'package:client/services/api_service.dart';

class UkmListPage extends StatefulWidget {
  const UkmListPage({super.key});

  @override
  State<UkmListPage> createState() => _UkmListPageState();
}

class _UkmListPageState extends State<UkmListPage> {
  late Future<List<Ukm>> _ukmsFuture;

  @override
  void initState() {
    super.initState();
    _loadUkms();
  }

  Future<void> _loadUkms() async {
    setState(() {
      _ukmsFuture = _fetchUkms();
    });
  }

  Future<List<Ukm>> _fetchUkms() async {
    try {
      final response = await ApiService.instance.getUkms();
      final List<dynamic> data = response.data;
      return data.map((json) => Ukm.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data UKM: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar UKM')),
      body: RefreshIndicator(
        onRefresh: _loadUkms, 
        child: FutureBuilder<List<Ukm>>(
          future: _ukmsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Gagal memuat data.\nError: ${snapshot.error}\n\nTarik ke bawah untuk mencoba lagi.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada UKM yang tersedia.'));
            }

            final ukms = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0), 
              itemCount: ukms.length,
              itemBuilder: (context, index) {
                final ukm = ukms[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: ukm.logoUrl != null ? NetworkImage(ukm.logoUrl!) : null,
                      child: ukm.logoUrl == null ? const Icon(Icons.groups) : null,
                    ),
                    title: Text(ukm.namaUkm, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(ukm.kategori ?? 'Tanpa Kategori'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => UkmDetailPage(ukmId: ukm.id),
                      ));
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}