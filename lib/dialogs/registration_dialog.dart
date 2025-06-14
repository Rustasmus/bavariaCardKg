import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/auth/auth_event.dart';

class RegistrationDialog extends StatefulWidget {
  const RegistrationDialog({super.key});

  @override
  State<RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<RegistrationDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _bmwModelController = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _firstNameController.dispose();
    _middleNameController.dispose();
    _bmwModelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Диспатчим регистрацию через Bloc
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phone: _phoneController.text.trim(),
            birthDate: _birthDateController.text.trim(),
            firstName: _firstNameController.text.trim(),
            middleName: _middleNameController.text.trim(),
            bmwModel: _bmwModelController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthError) {
            setState(() => _errorMessage = state.message);
          }
          if (state is AuthRegistered) {
            // Показываем диалог об успешной регистрации
            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Регистрация успешна'),
                content: const Text(
                    'Вам отправлено письмо для подтвержения регистрации'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Закрываем диалог
                      Navigator.of(context).pop(); // Закрываем регистрацию
                    },
                    child: const Text('ОК'),
                  )
                ],
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 12),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Введите email';
                    }
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(val)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (val.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Телефон *',
                    hintText: '+996...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Введите телефон';
                    }
                    if (!val.startsWith('+')) {
                      return 'Телефон должен начинаться с "+"';
                    }
                    if (!RegExp(r'^\+\d{11,15}$').hasMatch(val)) {
                      return 'Введите телефон в формате +996XXXXXXXXX';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _birthDateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: 'Дата рождения (например, 01.01.2000) *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Введите дату рождения';
                    }
                    if (!RegExp(r'^\d{2}\.\d{2}\.\d{4}$').hasMatch(val)) {
                      return 'Формат: ДД.ММ.ГГГГ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Имя *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Введите имя' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _middleNameController,
                  decoration: const InputDecoration(
                    labelText: 'Отчество *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Введите отчество' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _bmwModelController,
                  decoration: const InputDecoration(
                    labelText: 'Модель BMW *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => (val == null || val.isEmpty)
                      ? 'Введите модель BMW'
                      : null,
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: isLoading ? null : _submit,
                            child: const Text('Зарегистрироваться'),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showRegistrationDialog(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const RegistrationDialog(),
    ),
  );
}
