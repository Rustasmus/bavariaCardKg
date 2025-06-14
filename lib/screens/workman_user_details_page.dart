import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../widgets/records_history_dialog.dart';
import '../dialogs/add_record_dialog.dart';
import '../utils/record_utils.dart';
import '../utils/workman_utils.dart';
import 'workmans_home_page.dart';

class WorkmanUserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userUid;
  final VoidCallback onSignOut;

  const WorkmanUserDetailsPage({
    required this.userData,
    required this.userUid,
    required this.onSignOut,
    super.key,
  });

  @override
  State<WorkmanUserDetailsPage> createState() => _WorkmanUserDetailsPageState();
}

class _WorkmanUserDetailsPageState extends State<WorkmanUserDetailsPage> {
  double? lastBonus;
  bool loadingBonus = false;

  @override
  void initState() {
    super.initState();
    _loadLastBonus();
  }

  Future<void> _loadLastBonus() async {
    setState(() {
      loadingBonus = true;
      lastBonus = 0.0;
    });

    final recordsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUid)
        .collection('records');
    final lastRecordSnapshot =
        await recordsRef.orderBy('date', descending: true).limit(1).get();

    if (!mounted) return; // <-- mounted только тут, после await!
    setState(() {
      loadingBonus = false;
      if (lastRecordSnapshot.docs.isNotEmpty) {
        final docData = lastRecordSnapshot.docs.first.data();
        lastBonus = (docData['bonus_available'] as num?)?.toDouble() ?? 0.0;
      } else {
        lastBonus = 0.0;
      }
    });
  }

  void _showAddRecordDialog() async {
    // showDialog НЕ асинхронная операция по сути, context ОК
    await showDialog(
      context: context,
      builder: (dialogContext) => AddRecordDialog(
        lastBonusAvailable: lastBonus ?? 0.0,
        onSave: ({
          required int order,
          required double amount,
          required double bonusOut,
        }) async {
          // Все async после нажатия "Сохранить"
          final workmanEmail = await getCurrentWorkmanEmail();
          final workmanID = await getWorkmanKeyByEmail(workmanEmail);
          final error = await addClientRecord(
            userUid: widget.userUid,
            order: order,
            amount: amount,
            bonusOut: bonusOut,
            workmanID: workmanID,
          );
          // ВНИМАНИЕ: используем context из State, но только после проверки mounted!
          if (!mounted) return;
          if (error == null) {
            await _loadLastBonus();
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Запись успешно добавлена!')),
            );
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String fio = [
      widget.userData['firstName'] ?? '',
      widget.userData['middleName'] ?? ''
    ].where((e) => e.toString().isNotEmpty).join(' ');
    String email = widget.userData['email'] ?? '-';
    String phone = widget.userData['phone'] ?? '-';

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
            onPressed: () {
              // Выход через Bloc
              context.read<AuthBloc>().add(AuthLogoutRequested());
              // После выхода AuthGate сам покажет нужный экран
            },
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
              children: [
                const Icon(Icons.star, size: 20, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Бонусы: ', style: TextStyle(fontSize: 18)),
                loadingBonus
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                        (lastBonus ?? 0.0).toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: loadingBonus ? null : _showAddRecordDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Добавить запись"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // showDialog — контекст из State, не после await, всё ОК
                      showDialog(
                        context: context,
                        builder: (context) => RecordsHistoryDialog(
                          userUid: widget.userUid,
                          title: "История начислений",
                          headerColor: Colors.deepPurple,
                          evenRowColor: Colors.grey[200],
                          oddRowColor: Colors.white,
                        ),
                      );
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
          ],
        ),
      ),
    );
  }
}

/// Хелпер для получения email текущего workman-а
Future<String> getCurrentWorkmanEmail() async {
  final auth = FirebaseAuth.instance;
  return auth.currentUser?.email ?? 'unknown';
}
