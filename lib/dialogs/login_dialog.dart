// login_dialog.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'registration_dialog.dart';

void showLoginDialog(BuildContext context) {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Вход'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Пароль'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authService = AuthService();
              String? result = await authService.loginUser(
                emailController.text.trim(),
                passwordController.text.trim(),
              );

              if (result == null) {
                Navigator.pop(context);
              } else {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Ошибка входа'),
                    content: Text(result),
                  ),
                );
              }
            },
            child: Text('Войти'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              showRegistrationDialog(context); // Подключить после добавления registration_dialog
            },
            child: Text('Регистрация'),
          ),
        ],
      );
    },
  );
}