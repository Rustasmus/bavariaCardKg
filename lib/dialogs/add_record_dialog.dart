import 'package:flutter/material.dart';

class AddRecordDialog extends StatefulWidget {
  final double lastBonusAvailable;
  final Function({
    required int order,
    required double amount,
    required double bonusOut,
  }) onSave;

  const AddRecordDialog({
    super.key,
    required this.lastBonusAvailable,
    required this.onSave,
  });

  @override
  State<AddRecordDialog> createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _orderController = TextEditingController();
  final _amountController = TextEditingController();
  final _bonusOutController = TextEditingController();

  @override
  void dispose() {
    _orderController.dispose();
    _amountController.dispose();
    _bonusOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return AlertDialog(
      title: const Text('Добавить запись'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Дата: ${now.day}.${now.month}.${now.year}'),
              TextFormField(
                controller: _orderController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Номер документа'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Введите номер документа';
                  return int.tryParse(val) != null ? null : 'Только число';
                },
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                
                decoration: const InputDecoration(labelText: 'Сумма к оплате 💸'),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Введите сумму';
                  return double.tryParse(val.replaceAll(',', '.')) != null ? null : 'Только число';
                },
              ),
              TextFormField(
                controller: _bonusOutController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Оплата Бонусами ${widget.lastBonusAvailable.toStringAsFixed(2)}',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return null;
                  final value = double.tryParse(val.replaceAll(',', '.')) ?? 0;
                  if (value < 0) return 'Не может быть меньше 0';
                  if (value > widget.lastBonusAvailable) return 'Максимум ${widget.lastBonusAvailable.toStringAsFixed(2)}';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final order = int.tryParse(_orderController.text) ?? 0;
              final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0.0;
              final bonusOut = double.tryParse(_bonusOutController.text.replaceAll(',', '.')) ?? 0.0;
              widget.onSave(order: order, amount: amount, bonusOut: bonusOut);
              Navigator.pop(context);
            }
          },
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
