import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordsHistoryDialog extends StatefulWidget {
  final String userUid;
  final String title;
  final Color headerColor;
  final Color? evenRowColor;
  final Color? oddRowColor;

  const RecordsHistoryDialog({
    super.key,
    required this.userUid,
    this.title = "История начислений",
    this.headerColor = Colors.deepPurple,
    this.evenRowColor,
    this.oddRowColor,
  });

  @override
  State<RecordsHistoryDialog> createState() => _RecordsHistoryDialogState();
}

class _RecordsHistoryDialogState extends State<RecordsHistoryDialog> {
  bool loading = true;
  List<Map<String, dynamic>> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => loading = true);
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userUid)
        .collection('records')
        .orderBy('date', descending: true)
        .limit(10)
        .get();

    records = snap.docs.map((doc) => doc.data()).toList();
    setState(() => loading = false);
  }

  Widget _buildHeader() => Container(
        color: widget.headerColor,
        child: Row(
          children: const [
            _Cell('Дата', width: 80, isHeader: true),
            _Cell('Заказ', width: 50, isHeader: true),
            _Cell('Сумма', width: 70, isHeader: true),
            _Cell('Списание', width: 70, isHeader: true),
            _Cell('Остаток', width: 70, isHeader: true),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: loading
          ? const SizedBox(
              width: 60,
              height: 60,
              child: Center(child: CircularProgressIndicator()))
          : records.isEmpty
              ? const Text('Нет записей')
              : SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(),
                        ...records.mapIndexed((i, rec) {
                          final DateTime? date = rec['date'] is Timestamp
                              ? (rec['date'] as Timestamp).toDate()
                              : (rec['date'] is DateTime ? rec['date'] : null);
                          final rowColor = (i % 2 == 0)
                              ? widget.evenRowColor ?? Colors.grey[50]
                              : widget.oddRowColor ?? Colors.white;
                          return Container(
                            color: rowColor,
                            child: Row(
                              children: [
                                _Cell(
                                  date != null
                                      ? '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}'
                                      : '-',
                                  width: 80,
                                ),
                                _Cell('№${rec['order'] ?? "-"}', width: 50),
                                _Cell((rec['amount'] ?? 0).toStringAsFixed(2),
                                    width: 70),
                                _Cell(
                                    (rec['bonus_out'] ?? 0).toStringAsFixed(2),
                                    width: 70,
                                    color: Colors.red),
                                _Cell(
                                    (rec['bonus_available'] ?? 0)
                                        .toStringAsFixed(2),
                                    width: 70,
                                    color: Colors.green),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Закрыть'),
        ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;
  final double width;
  final bool isHeader;
  final Color? color;

  const _Cell(this.text,
      {required this.width, this.isHeader = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color ?? (isHeader ? Colors.white : Colors.black),
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}

// Для mapIndexed:
extension _ListMapIndexed<E> on List<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) sync* {
    int i = 0;
    for (final e in this) {
      yield f(i++, e);
    }
  }
}
