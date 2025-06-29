import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/models/user.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/proposal_review_page.dart';
import 'package:client/screens/ukm_proposal_form_page.dart';
import 'package:client/screens/my_ukm_page.dart';
import 'package:client/screens/manage_ukm_page.dart';
import 'package:client/screens/my_profile_page.dart';
import 'package:client/screens/manage_kegiatan_page.dart';
import 'package:client/screens/delete_ukm_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return SingleChildScrollView(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            _ProfileHeader(user: user),
            _ActionCard(user: user),
            _MenuList(user: user), 
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;
  const _ProfileHeader({this.user});

  String _buildRoleText(User? user) {
    if (user == null) return 'Pengguna';

    switch (user.role) {
      case 'super_admin':
        return 'Super Administrator';
      case 'admin_ukm':
        final ukmName = user.ukmAdmin?.namaUkm ?? 'UKM';
        return 'Admin $ukmName';
      case 'mahasiswa':
      default:
        return 'Mahasiswa';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 90, bottom: 80, left: 24, right: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Column( 
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: user?.fotoProfilUrl != null ? NetworkImage(user!.fotoProfilUrl!) : null,
              child: user?.fotoProfilUrl == null ? Text(user?.name.substring(0, 1).toUpperCase() ?? 'A', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)) : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? 'Pengguna',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'NIM: ${user?.nim ?? '-'}',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
              ),
              const Text(" • ", style: TextStyle(color: Colors.white70)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Text(
                  _buildRoleText(user),
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final User? user;
  const _ActionCard({this.user});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRoleSpecificActionButton(context, user),
              _ActionButton(icon: Icons.card_membership, label: 'UKM Saya', onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const MyUkmPage(),
                  ));
              }),
              if (user?.role == 'admin_ukm')
                _ActionButton(
                  icon: Icons.edit_calendar,
                  label: 'Kelola Kegiatan', 
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ManageKegiatanPage(),
                    ));
                  },
                )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSpecificActionButton(BuildContext context, User? user) {
    if (user?.role == 'super_admin') {
      return _ActionButton(icon: Icons.rule_folder, label: 'Daftar Ajuan', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProposalReviewPage())));
    } else if (user?.role == 'admin_ukm') {
      return _ActionButton(icon: Icons.edit_square, label: 'Kelola UKM', onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const ManageUkmPage(),
        ));
      });
    } else {
      return _ActionButton(icon: Icons.add_business, label: 'Ajukan UKM', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UkmProposalFormPage())));
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
                const SizedBox(height: 8),
                Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuList extends StatelessWidget {
  final User? user;
  const _MenuList({this.user});
  
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Ya, Logout'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            if (user?.role == 'super_admin') ...[
                _MenuTile(
                  icon: Icons.delete_forever,
                  title: 'Hapus Data UKM',
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DeleteUkmPage(),
                    ));
                  },
                ),
                const Divider(height: 1),
              ],
            _MenuTile(icon: Icons.person_outline, title: 'Profil Saya', onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyProfilePage()));
            }),
            const Divider(height: 1),
            _MenuTile(
              icon: Icons.logout,
              title: 'Logout',
              color: Colors.red,
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  const _MenuTile({required this.icon, required this.title, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: color == null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}