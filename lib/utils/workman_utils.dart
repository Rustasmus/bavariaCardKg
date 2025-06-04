import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isWorkmanByEmail(String email) async {
  final doc = await FirebaseFirestore.instance
      .collection('workmans')
      .doc('MOsntYo03RweD3Iqc8Uq')
      .get();

  final data = doc.data();
  if (data == null) return false;

  final result = data.values.any((v) =>
      v.toString().trim().toLowerCase() == email.trim().toLowerCase());
  return result;
}

/// Возвращает ключ (имя workman), если email найден в workmans
Future<String> getWorkmanKeyByEmail(String email) async {
  final doc = await FirebaseFirestore.instance
      .collection('workmans')
      .doc('MOsntYo03RweD3Iqc8Uq')
      .get();

  final data = doc.data();
  if (data == null) return 'unknown';

  for (final entry in data.entries) {
    if ((entry.value as String).toLowerCase() == email.toLowerCase()) {
      return entry.key;
    }
  }
  return 'unknown';
}