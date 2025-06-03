import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'guest_home_page.dart';
import 'user_home_page.dart';
import 'workmans_home_page.dart';
import '../utils/workman_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.userChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) {
          return GuestHomePage();
        }
        // Проверяем, сотрудник или нет
        return FutureBuilder<bool>(
          future: isWorkmanByEmail(user.email!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (snapshot.data == true) {
              return const WorkmansHomePage();
            } else {
              return const UserHomePage();
            }
          },
        );
      },
    );
  }
}
