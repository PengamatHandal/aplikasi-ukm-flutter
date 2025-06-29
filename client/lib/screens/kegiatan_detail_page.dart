// lib/screens/kegiatan_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl
import 'package:client/models/kegiatan.dart';
import 'package:client/services/api_service.dart';

class KegiatanDetailPage extends StatefulWidget {
  final int kegiatanId;
  const KegiatanDetailPage({super.key, required this.kegiatanId});

  @override
  State<KegiatanDetailPage> createState() => _KegiatanDetailPageState();
}

class _KegiatanDetailPageState extends State<KegiatanDetailPage> {
  late Future<Kegiatan> _kegiatanDetailFuture;

  @override
  void initState() {
    super.initState();
    _kegiatanDetailFuture = _fetchKegiatanDetail();
  }

  Future<Kegiatan> _fetchKegiatanDetail() async {
    try {
      final response = await ApiService.instance.getKegiatanDetail(widget.kegiatanId);
      return Kegiatan.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal memuat detail kegiatan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Kegiatan>(
        future: _kegiatanDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('Kegiatan tidak ditemukan.'));
          }

          final kegiatan = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    kegiatan.judul,
                    style: const TextStyle(fontSize: 16, shadows: [
                      Shadow(blurRadius: 10, color: Colors.black54)
                    ]),
                  ),
                  background: kegiatan.gambarUrl != null
                      ? Image.network(
                          kegiatan.gambarUrl!,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.3),
                          colorBlendMode: BlendMode.darken,
                        )
                      : Container(color: Theme.of(context).primaryColor),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kegiatan.judul,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Chip(
                            avatar: const Icon(Icons.groups, size: 18),
                            label: Text(kegiatan.ukm?.namaUkm ?? 'UKM'),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(kegiatan.tanggalAcara),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                       Row(
                        children: [
                           const Icon(Icons.location_on, size: 14, color: Colors.grey),
                           const SizedBox(width: 4),
                           Text(
                            kegiatan.lokasi,
                            style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(
                        kegiatan.deskripsi,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}