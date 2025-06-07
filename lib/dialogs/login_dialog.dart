import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'registration_dialog.dart';
// import '../screens/workmans_home_page.dart';
// import '../screens/user_home_page.dart';
// import '../utils/workman_utils.dart'; // импортируем функцию проверки

void showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const LoginDialog(),
  );
}

class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String? error;
  bool isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    final result = await authService.loginUser(email, password);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    if (result == null) {
       Navigator.of(context).pop(); // Просто закрываем диалог, больше ничего!
      // AuthGate автоматически отобразит нужную страницу!
    } else {
      setState(() {
        error = result;
      });
    }      
  }

  @override
  Widget build(BuildContext context) {
    // Вместо Scaffold используем Dialog с фирменным стилем
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
      child: Stack(
        children: [
          // Фоновый слой: карбон + белый фильтр (как BurDrawer)
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/carbon_bra.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(32),
                /*boxShadow: [
                   BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],*/
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 1),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Логотип/шапка
                      const SizedBox(height: 22),
                      Text(
                        "Авторизация",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 10,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255), // ← вот это и есть цвет вводимого текста
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 10,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                            shadows:[
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(
                            color: Colors.orange, // Задай любой нужный цвет ошибки!
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 8,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        onChanged: (val) => email = val.trim(),
                        validator: (val) =>
                            val != null && val.contains('@') ? null : 'Введите корректный email',
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255), // ← вот это и есть цвет вводимого текста
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 10,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 10,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                            shadows:[
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 10,
                                color: Colors.black54,
                              )
                            ],
                          ),
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(
                            color: Colors.orange, // Задай любой нужный цвет ошибки!
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 8,
                                color: Colors.black54,
                              ),
                            ],
                          )
                        ),
                        obscureText: true,
                        onChanged: (val) => password = val.trim(),
                        validator: (val) => val != null && val.length >= 6 ? null : 'Мин. 6 символов',
                        autofillHints: const [AutofillHints.password],
                      ),
                      const SizedBox(height: 16),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 215, 0),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: isLoading ? null : _submit,
                              child: isLoading
                                  ? const SizedBox(
                                      width: 18, height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Text('Войти'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.pop(context);
                                showRegistrationDialog(context);
                              },
                        child: const Text(
                          'Нет аккаунта? Зарегистрируйтесь',
                          style: TextStyle(
                            color: Color.fromARGB(255, 97, 158, 229),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
