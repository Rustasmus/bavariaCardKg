import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'screens/guest_home_page.dart';
import 'screens/user_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // другие провайдеры
      ],
      child: const BavariaApp(),
    ),
  );
}

class BavariaApp extends StatelessWidget {
  const BavariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bavaria.kg',
        debugShowCheckedModeBanner: false,
        home: const RootPage(),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return StreamBuilder<User?>(
      stream: authService.userChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) {
          return UserHomePage();
        } else {
          return GuestHomePage();
        }
      },
    );
  }
}
