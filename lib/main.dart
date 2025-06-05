import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const BavariaApp());
}

class BavariaApp extends StatelessWidget {
  const BavariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Bavaria.kg',
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(), // теперь сначала Splash, потом AuthGate
      ),
    );
  }
}
