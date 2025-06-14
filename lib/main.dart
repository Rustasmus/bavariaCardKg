import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart'; // добавь это
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // добавь эту строку
  await Firebase.initializeApp(); // инициализация Firebase
  runApp(const BavariaApp());
}

class BavariaApp extends StatelessWidget {
  const BavariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => AuthBloc()..add(AuthStarted()),
      child: MaterialApp(
        title: 'Bavaria.kg',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
