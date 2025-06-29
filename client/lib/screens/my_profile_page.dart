// lib/screens/my_profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/edit_profile_page.dart';

class MyProfilePage extends StatelessWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Profil Saya'),
            pinned: true,
            expandedHeight: 250.0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Profil',
                onPressed: () {
                  if (user != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfilePage(currentUser: user),
                    ));
                  }
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderBackground(context, user),
            ),
          ),
          SliverToBoxAdapter(
            child: user == null
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text('Gagal memuat data pengguna.'),
                  ))
                : _buildProfileContent(context, user),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground(BuildContext context, User? user) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 47,
              backgroundImage: user?.fotoProfilUrl != null ? NetworkImage(user!.fotoProfilUrl!) : null,
              child: user?.fotoProfilUrl == null ? Text(user?.name.substring(0, 1).toUpperCase() ?? 'A', style: const TextStyle(fontSize: 40)) : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'Pengguna',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Informasi Pribadi", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildInfoTile(context, icon: Icons.badge_outlined, title: 'NIM', subtitle: user.nim ?? '-'),
                const Divider(height: 1, indent: 56),
                _buildInfoTile(context, icon: Icons.email_outlined, title: 'Email', subtitle: user.email ?? '-'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text("Status Keanggotaan", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                _buildInfoTile(context, icon: Icons.admin_panel_settings_outlined, title: 'Role Akun', subtitle: user.role ?? '-'),
                if(user.role == 'admin_ukm') ...[
                  const Divider(height: 1, indent: 56),
                   _buildInfoTile(context, icon: Icons.groups_2_outlined, title: 'Admin UKM', subtitle: user.ukmAdmin?.namaUkm ?? 'Belum ada'),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
    );
  }
}