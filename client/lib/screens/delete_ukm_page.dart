// lib/screens/delete_ukm_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/ukm.dart';
import 'package:client/services/api_service.dart';

class DeleteUkmPage extends StatefulWidget {
  const DeleteUkmPage({super.key});

  @override
  State<DeleteUkmPage> createState() => _DeleteUkmPageState();
}

class _DeleteUkmPageState extends State<DeleteUkmPage> {
  late Future<List<Ukm>> _ukmsFuture;

  @override
  void initState() {
    super.initState();
    _loadUkms();
  }

  void _loadUkms() {
    setState(() {
      _ukmsFuture = ApiService.instance.getUkms().then(
        (response) => (response.data as List).map((json) => Ukm.fromJson(json)).toList()
      );
    });
  }

  Future<void> _confirmDelete(Ukm ukm) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus ${ukm.namaUkm}?'),
        content: const Text('Aksi ini tidak dapat dibatalkan. Semua data terkait (kegiatan, anggota) juga akan terhapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya, Hapus'),
          )
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await ApiService.instance.deleteUkm(ukm.id);
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${ukm.namaUkm} berhasil dihapus.'), backgroundColor: Colors.green));
        }
        _loadUkms(); 
      } catch (e) {
         if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus UKM: $e'), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hapus Data UKM')),
      body: FutureBuilder<List<Ukm>>(
        future: _ukmsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Semua UKM sudah terhapus.'));
          }
          
          final ukms = snapshot.data!;
          return ListView.builder(
            itemCount: ukms.length,
            itemBuilder: (context, index) {
              final ukm = ukms[index];
              return ListTile(
                leading: CircleAvatar(backgroundImage: ukm.logoUrl != null ? NetworkImage(ukm.logoUrl!) : null),
                title: Text(ukm.namaUkm),
                subtitle: Text('Admin: ${ukm.admin?.name ?? 'N/A'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                  onPressed: () => _confirmDelete(ukm),
                ),
              );
            },
          );
        },
      ),
    );
  }
}