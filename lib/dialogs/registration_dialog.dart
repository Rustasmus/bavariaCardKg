// registration_dialog.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';

void showRegistrationDialog(BuildContext context) {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final bmwController = TextEditingController();
  final passwordController = TextEditingController();

  DateTime? selectedDate;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Регистрация'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email *'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Телефон *'),
                  ),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'Имя'),
                  ),
                  TextField(
                    controller: middleNameController,
                    decoration: InputDecoration(labelText: 'Отчество'),
                  ),
                  TextField(
                    controller: bmwController,
                    decoration: InputDecoration(labelText: 'BMW модель'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Пароль *'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(selectedDate == null
                            ? 'Дата рождения *'
                            : DateFormat('yyyy-MM-dd').format(selectedDate!)),
                      ),
                      TextButton(
                        onPressed: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2000),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Text('Выбрать дату'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Отмена'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      passwordController.text.isEmpty ||
                      selectedDate == null) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Ошибка'),
                        content: Text('Пожалуйста, заполните все обязательные поля.'),
                      ),
                    );
                    return;
                  }

                  final authService = AuthService();
                  String? result = await authService.registerUser(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    phone: phoneController.text.trim(),
                    birthDate: selectedDate!.toIso8601String(),
                    firstName: firstNameController.text.trim(),
                    middleName: middleNameController.text.trim(),
                    bmwModel: bmwController.text.trim(),
                  );

                  if (result == null) {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Регистрация завершена'),
                        content: Text('Проверьте email для подтверждения.\n'),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Ошибка регистрации'),
                        content: Text(result),
                      ),
                    );
                  }
                },
                child: Text('Зарегистрироваться'),
              ),
            ],
          );
        },
      );
    },
  );
}
