// lib/screens/manage_ukm_page.dart
import 'package:flutter/material.dart';
import 'package:client/models/ukm.dart';
import 'package:client/models/keanggotaan.dart';
import 'package:client/services/api_service.dart';

class ManageUkmPage extends StatefulWidget {
  const ManageUkmPage({super.key});

  @override
  State<ManageUkmPage> createState() => _ManageUkmPageState();
}

class _ManageUkmPageState extends State<ManageUkmPage> {
  Ukm? _managedUkm;
  List<Keanggotaan> _pendingMemberships = [];
  List<Keanggotaan> _approvedMemberships = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.instance.getManagedUkm();
      setState(() {
        _managedUkm = Ukm.fromJson(response.data['ukm']);
        _pendingMemberships = (response.data['pending_anggota'] as List)
            .map((json) => Keanggotaan.fromJson(json))
            .toList();
        // Parsing data anggota aktif dari key baru
        _approvedMemberships = (response.data['approved_anggota'] as List)
            .map((json) => Keanggotaan.fromJson(json))
            .toList();
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleRegistration() async {
    final response = await ApiService.instance.toggleUkmRegistration();
    setState(() {
      _managedUkm = _managedUkm?.copyWith(isPendaftaranBuka: response.data['is_pendaftaran_buka']);
    });
  }
  
  Future<void> _handleMembershipAction(int membershipId, bool isApproved) async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memproses...'), duration: Duration(seconds: 1)));

    try {
      if (isApproved) {
        await ApiService.instance.approveMember(membershipId);
      } else {
        await ApiService.instance.removeMember(membershipId);
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isApproved ? 'Anggota disetujui!' : 'Pendaftar ditolak.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Aksi gagal.'), backgroundColor: Colors.red));
      }
    } finally {
      _loadData();
    }
  }

  Future<void> _removeMember(int membershipId) async {
    final bool? shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluarkan Anggota'),
        content: const Text('Apakah Anda yakin ingin mengeluarkan anggota ini dari UKM?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya, Keluarkan'),
          ),
        ],
      ),
    );

    if (shouldRemove == true) {
      try {
        await ApiService.instance.removeMember(membershipId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anggota berhasil dikeluarkan.'), backgroundColor: Colors.orange));
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengeluarkan anggota.'), backgroundColor: Colors.red));
      } finally {
        _loadData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola UKM')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _managedUkm == null
              ? const Center(child: Text('Anda bukan admin UKM manapun.'))
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        child: SwitchListTile(
                          title: const Text('Pendaftaran Dibuka', style: TextStyle(fontWeight: FontWeight.bold)),
                          value: _managedUkm!.isPendaftaranBuka,
                          onChanged: (value) => _toggleRegistration(),
                          secondary: const Icon(Icons.door_front_door),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Pendaftar Baru', style: Theme.of(context).textTheme.titleLarge),
                      const Divider(),
                      if (_pendingMemberships.isEmpty)
                        const Padding(padding: EdgeInsets.all(16), child: Text('Tidak ada pendaftar baru.'))
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _pendingMemberships.length,
                          itemBuilder: (context, index) {
                            final membership = _pendingMemberships[index];
                            return ListTile(
                              leading: CircleAvatar(child: Text(membership.user.name.substring(0,1))),
                              title: Text(membership.user.name),
                              subtitle: Text(membership.user.nim ?? ''),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Tombol Tolak
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _handleMembershipAction(membership.id, false),
                                  ),
                                  // Tombol Setujui
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => _handleMembershipAction(membership.id, true),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      
                      const SizedBox(height: 24),
                      // Daftar Anggota Aktif
                      Text('Anggota Aktif', style: Theme.of(context).textTheme.titleLarge),
                      const Divider(),
                        if (_managedUkm!.anggota!.isEmpty)
                          const Padding(padding: EdgeInsets.all(16), child: Text('Belum ada anggota aktif.'))
                        else
                          ..._approvedMemberships.map((membership) => ListTile(
                              leading: CircleAvatar(child: Text(membership.user.name.substring(0,1))),
                              title: Text(membership.user.name),
                              subtitle: Text(membership.user.nim ?? ''),
                              trailing: IconButton(
                                icon: const Icon(Icons.person_remove_outlined, color: Colors.redAccent),
                                onPressed: () => _removeMember(membership.id),
                              ),
                            )),
                    ],
                  ),
                ),
    );
  }
}