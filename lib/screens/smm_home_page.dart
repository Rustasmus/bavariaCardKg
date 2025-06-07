import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart'; // Если используешь AuthService
import '../dialogs/packages_dialog.dart';
import '../dialogs/news_dialog.dart';
import '../dialogs/promo_dialog.dart';

class SmmHomePage extends StatelessWidget {
  const SmmHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SMM',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 26,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 8,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SmmButton(
                icon: Icons.article_outlined,
                label: 'Новости',
                color: Colors.blueAccent.shade700,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const NewsDialog(),
                  );
                },
              ),
              const SizedBox(height: 18),
              _SmmButton(
                icon: Icons.local_offer_outlined,
                label: 'Акции',
                color: Colors.amber.shade800,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) =>
                        const PromoDialog(),
                  );
                },
              ),
              const SizedBox(height: 18),
              _SmmButton(
                icon: Icons.card_giftcard_outlined,
                label: 'Пакеты',
                color: Colors.green.shade700,
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (_) =>
                        const PackagesDialog(), // <-- твой виджет диалога
                  );
                },
              ),
              const SizedBox(height: 28),
              _SmmButton(
                icon: Icons.notifications_active_outlined,
                label: 'Отправить Push уведомление',
                color: Colors.red.shade600,
                onTap: () {
                  // TODO: реализуй отправку push
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Push уведомление отправлено!')),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Кнопка "Выйти"
              ElevatedButton.icon(
                icon: const Icon(Icons.exit_to_app),
                label: const Text("Выйти"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 48),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () async {
                  // Если используешь Provider + AuthService:
                  await Provider.of<AuthService>(context, listen: false)
                      .logout();
                  // Если нет - можно так:
                  // await FirebaseAuth.instance.signOut();
                  // AuthGate обработает выход
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Красивая фирменная кнопка SMM (универсально для страницы)
class _SmmButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _SmmButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 50,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(letterSpacing: 0.8),
        ),
        onPressed: onTap,
      ),
    );
  }
}
