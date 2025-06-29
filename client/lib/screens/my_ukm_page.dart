// lib/screens/my_ukm_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/ukm.dart';
import 'package:client/screens/ukm_detail_page.dart';
import 'package:client/services/api_service.dart';

class MyUkmPage extends StatefulWidget {
  const MyUkmPage({super.key});

  @override
  State<MyUkmPage> createState() => _MyUkmPageState();
}

class _MyUkmPageState extends State<MyUkmPage> {
  late Future<List<Ukm>> _myUkmsFuture;

  @override
  void initState() {
    super.initState();
    _loadMyUkms();
  }

  Future<void> _loadMyUkms() async {
    setState(() {
      _myUkmsFuture = _fetchMyUkms();
    });
  }

  Future<List<Ukm>> _fetchMyUkms() async {
    try {
      final response = await ApiService.instance.getMyUkms();
      // API ini tidak dipaginasi, jadi langsung ambil list-nya
      final List<dynamic> data = response.data;
      return data.map((json) => Ukm.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat data UKM Saya: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UKM Saya'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadMyUkms,
        child: FutureBuilder<List<Ukm>>(
          future: _myUkmsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('Anda belum mengikuti UKM apapun.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              );
            }

            final myUkms = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: myUkms.length,
              itemBuilder: (context, index) {
                final ukm = myUkms[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
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