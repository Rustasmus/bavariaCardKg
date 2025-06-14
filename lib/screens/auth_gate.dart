import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

import 'guest_home_page.dart';
import 'user_home_page.dart';
import 'workmans_home_page.dart';
import 'smm_home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (state is AuthGuest) {
          return const GuestHomePage();
        }
        if (state is AuthSmm) {
          return const SmmHomePage();
        }
        if (state is AuthWorkman) {
          return const WorkmansHomePage();
        }
        if (state is AuthUser) {
          return const UserHomePage();
        }
        if (state is AuthError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        return const Scaffold(body: Center(child: Text("Неизвестное состояние")));
      },
    );
  }
}
