import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminLoginDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  const AdminLoginDialog({required this.onSuccess, super.key});

  @override
  State<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends State<AdminLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  String login = '';
  String password = '';
  bool loading = false;
  String? error;

  Future<bool> _checkAdminCreds(String login, String password) async {
    final snap = await FirebaseFirestore.instance.collection('workmans').doc('Z5ia2pqUizmKwl1vN05b').get();
    final data = snap.data();
    if (data == null) return false;
    return (login == (data['mainUserL'] ?? '')) && (password == (data['mainUserP'] ?? ''));
  }

  void _tryLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      loading = true;
      error = null;
    });
    final ok = await _checkAdminCreds(login, password);
    setState(() => loading = false);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(); // Закроем диалог
      widget.onSuccess();          // Переход на admin
    } else {
      setState(() {
        error = "Неверный логин или пароль";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Вход администратора'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Логин'),
              onChanged: (v) => login = v.trim(),
              validator: (v) => v == null || v.isEmpty ? "Введите логин" : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              onChanged: (v) => password = v.trim(),
              validator: (v) => v == null || v.isEmpty ? "Введите пароль" : null,
            ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: const Text("Отмена"),
        ),
        ElevatedButton(
          onPressed: loading ? null : _tryLogin,
          child: loading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Войти"),
        ),
      ],
    );
  }
}
