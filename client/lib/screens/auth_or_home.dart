import 'package:flutter/material.dart';
import 'package:client/providers/auth_provider.dart';
import 'package:client/screens/dashboard_page.dart';
import 'package:client/screens/main_page.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (auth.isLoggedIn) {
          return const DashboardPage();
        } else {
          return const MainPage();
        }
      },
    );
  }
}