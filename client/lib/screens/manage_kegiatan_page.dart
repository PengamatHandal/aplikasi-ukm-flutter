// lib/screens/manage_kegiatan_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/kegiatan.dart';
import 'package:client/services/api_service.dart';
import 'package:client/screens/upsert_kegiatan_page.dart'; // Akan kita buat

class ManageKegiatanPage extends StatefulWidget {
  const ManageKegiatanPage({super.key});

  @override
  State<ManageKegiatanPage> createState() => _ManageKegiatanPageState();
}

class _ManageKegiatanPageState extends State<ManageKegiatanPage> {
  late Future<List<Kegiatan>> _kegiatanFuture;

  @override
  void initState() {
    super.initState();
    _loadKegiatan();
  }

  void _navigateToUpsertPage({Kegiatan? kegiatan}) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => UpsertKegiatanPage(kegiatan: kegiatan),
    ));

    if (result == true) {
      _loadKegiatan();
    }
  }

  void _loadKegiatan() {
    setState(() {
      _kegiatanFuture = ApiService.instance.getManagedKegiatan().then(
        (response) => (response.data as List).map((json) => Kegiatan.fromJson(json)).toList()
      );
    });
  }

  void _deleteKegiatan(int id) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Hapus Kegiatan'),
      content: const Text('Apakah Anda yakin ingin menghapus kegiatan ini? Aksi ini tidak bisa dibatalkan.'),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Batal')),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Ya, Hapus'),
          onPressed: () async {
            Navigator.of(ctx).pop();
            await ApiService.instance.deleteKegiatan(id);
            _loadKegiatan(); 
          },
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kegiatan')),
      body: FutureBuilder<List<Kegiatan>>(
        future: _kegiatanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada kegiatan yang dibuat.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final kegiatan = snapshot.data![index];
              return ListTile(
                title: Text(kegiatan.judul),
                subtitle: Text('Lokasi: ${kegiatan.lokasi}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.edit, color: Colors.blue[400]), onPressed: () {
                      _navigateToUpsertPage(kegiatan: kegiatan);
                    }),
                    IconButton(icon: Icon(Icons.delete, color: Colors.red[400]), onPressed: () => _deleteKegiatan(kegiatan.id)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToUpsertPage();
        },
      ),
    );
  }
}