import 'package:cloud_firestore/cloud_firestore.dart';

Future<double> getDiscountFromWorkmansDoc() async {
  final doc = await FirebaseFirestore.instance
      .collection('workmans')
      .doc('MOsntYo03RweD3Iqc8Uq')
      .get();

  final data = doc.data();
  if (data == null) return 0.00; // дефолт

  final discountStr = data['discount'];
  if (discountStr != null) {
    final discount = double.tryParse(discountStr.toString());
    if (discount != null) return discount;
  }
  return 0.00;
}


/// Добавляет новую запись для пользователя и считает бонусы
Future<String?> addClientRecord({
  required String userUid,
  required int order,
  required double amount,
  required double bonusOut,
  required String workmanID,
}) async {
  try {
    final recordsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('records');

    // Получить последний bonus_available (если есть)
    final lastRecordSnapshot =
        await recordsRef.orderBy('date', descending: true).limit(1).get();

    double lastBonus = 0.0;
    if (lastRecordSnapshot.docs.isNotEmpty) {
      final docData = lastRecordSnapshot.docs.first.data();
      lastBonus = (docData['bonus_available'] as num?)?.toDouble() ?? 0.0;
    }

    // Логика расчёта нового bonus_available
    final discount = await getDiscountFromWorkmansDoc();
    final newBonus = lastBonus - bonusOut + amount * discount;

    await recordsRef.add({
      'date': Timestamp.now(),
      'order': order,
      'amount': amount,
      'bonus_out': bonusOut,
      'bonus_available': newBonus,
      'workmanID': workmanID,
    });

    return null; // успех
  } catch (e) {
    return 'Ошибка при добавлении записи: $e';
  }
}
