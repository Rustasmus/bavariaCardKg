import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';
import 'registration_dialog.dart';

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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // Диспатчим ивент логина в BLoC
    context.read<AuthBloc>().add(AuthLoginRequested(email, password));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            setState(() => error = state.message);
          }
          // На любой успешный вход — закрываем диалог
          if (state is AuthUser || state is AuthWorkman || state is AuthSmm) {
            Navigator.of(context).pop();
          }
        },
        child: Stack(
          children: [
            // Фон
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/main_fon.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 1),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                          style: const TextStyle(
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
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 10,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(
                              color: Colors.orange,
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
                          style: const TextStyle(
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
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 10,
                                  color: Colors.black54,
                                )
                              ],
                            ),
                            border: OutlineInputBorder(),
                            errorStyle: TextStyle(
                              color: Colors.orange,
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
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;
                                  return ElevatedButton(
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
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        TextButton(
                          onPressed: () {
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
      ),
    );
  }
}
