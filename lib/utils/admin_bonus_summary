import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminBonusSummary extends StatefulWidget {
  const AdminBonusSummary({super.key});

  @override
  State<AdminBonusSummary> createState() => _AdminBonusSummaryState();
}

class _AdminBonusSummaryState extends State<AdminBonusSummary> {
  double? sum;
  bool loading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadBonuses();
  }

  Future<void> _loadBonuses() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      double total = 0;
      final users = await FirebaseFirestore.instance.collection('users').get();

      for (final userDoc in users.docs) {
        final recordsSnap = await userDoc.reference
            .collection('records')
            .orderBy('date', descending: true)
            .limit(1)
            .get();
        if (recordsSnap.docs.isNotEmpty) {
          final bonus = (recordsSnap.docs.first.data()['bonus_available'] as num?)?.toDouble() ?? 0.0;
          total += bonus;
        }
      }
      setState(() {
        sum = total;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Суммарный бонус",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 32),
                const SizedBox(width: 16),
                loading
                    ? const CircularProgressIndicator()
                    : Text(
                        sum?.toStringAsFixed(2) ?? "--",
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: "Обновить",
                  onPressed: loading ? null : _loadBonuses,
                )
              ],
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Text("Ошибка: $error", style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
