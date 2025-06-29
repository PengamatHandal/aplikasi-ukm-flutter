// lib/screens/main_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/dashboard_page.dart';
import 'package:client/screens/kegiatan_list_page.dart';
import 'package:client/screens/login_page.dart';
import 'package:client/screens/ukm_list_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    final authProvider = context.read<AuthProvider>();
    if (index == 2 && !authProvider.isLoggedIn) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isLoggedIn = authProvider.isLoggedIn;

    final List<Widget> pages = [
      const KegiatanListPage(),
      const UkmListPage(),
      isLoggedIn
          ? DashboardPage(key: ValueKey(authProvider.user?.id))
          : LoginPage(onLoginSuccess: () => _onItemTapped(0)),
    ];

    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Beranda'),
      const BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Daftar UKM'),
      if (isLoggedIn)
        const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil')
      else
        const BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        
        // PROPERTI UNTUK STYLING
        backgroundColor: Theme.of(context).cardColor, 
        selectedItemColor: Theme.of(context).colorScheme.primary, 
        unselectedItemColor: Colors.grey[600], 
        selectedFontSize: 12, 
        unselectedFontSize: 12, 
        elevation: 10, 
      ),
    );
  }
}