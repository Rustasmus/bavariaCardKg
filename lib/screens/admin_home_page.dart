import 'package:flutter/material.dart';
import '../utils/admin_bonus_summary.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: const Text('Админ-панель')),
     body: ListView(
       children: const [
         AdminBonusSummary(), // <-- вот сюда!
         // ... другие админ-фичи
       ],
     ),
   );
  }
}
