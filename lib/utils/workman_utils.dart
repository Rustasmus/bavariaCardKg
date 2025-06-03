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
