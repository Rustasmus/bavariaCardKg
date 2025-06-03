import 'package:flutter/material.dart';
// import 'guest_home_page.dart';
import 'workmans_home_page.dart';

class WorkmanUserDetailsPage extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onSignOut;

  const WorkmanUserDetailsPage({
    required this.userData,
    required this.onSignOut,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Для красоты и устойчивости к пустым значениям
    String fio = [
      userData['firstname'] ?? '',
      userData['middlename'] ?? ''
    ].where((e) => e.toString().isNotEmpty).join(' ');
    String email = userData['email'] ?? '-';
    String phone = userData['phone'] ?? '-';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: "Назад к сканеру",
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const WorkmansHomePage()),
              (route) => false,
            );
          },
        ),
        title: const Text("Информация о клиенте"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Выйти",
            onPressed: onSignOut,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fio,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.email, size: 20),
                const SizedBox(width: 8),
                Text(email, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 20),
                const SizedBox(width: 8),
                Text(phone, style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.star, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text('Бонусы: ', style: TextStyle(fontSize: 18)),
                // Здесь позже будет динамический вывод бонусов
                Text('---', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: реализовать добавление записи
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Добавить запись"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: реализовать историю
                    },
                    icon: const Icon(Icons.history),
                    label: const Text("История"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 48),
                    ),
                  ),
                ],
              ),
            ),
            // Можно добавить доп. инфу ниже
          ],
        ),
      ),
    );
  }
}
