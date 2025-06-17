import 'package:flutter/material.dart';
import 'stroke_text.dart';
import 'bur_buttons.dart'; // <-- здесь твой кастомный GradientActionButton

class BurDrawer extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onHome;
  final VoidCallback? onContacts;
  final VoidCallback? onNews;
  final VoidCallback? onPromos;
  final VoidCallback? onReviews;
  final VoidCallback? onAbout;
  final VoidCallback? onPackages;

  const BurDrawer({
    this.onLogin,
    this.onHome,
    this.onPackages,
    this.onContacts,
    this.onNews,
    this.onPromos,
    this.onReviews,
    this.onAbout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/main_fon_grad.png'),
          fit: BoxFit.cover,
        ),
        gradient: const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black87,
            Colors.transparent,
          ],
          stops: [0, 0.7],
        ),
        color: const Color.fromARGB(255, 22, 88, 142).withOpacity(0.16),
      ),
      child: Column(
        children: [
          // Верхняя плашка с лого
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withOpacity(0.08),
                  blurRadius: 18,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 97, 158, 229).withOpacity(0.0),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 160, 175, 179).withOpacity(0.4),
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/images/logoF.png",
                  height: 70,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Используй свои кнопки!
          GradientActionButton(
            icon: Icons.login,
            label: 'Вход',
            onTap: onLogin ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.contacts,
            label: 'Контакты',
            onTap: onContacts ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.folder,
            label: 'Пакеты',
            onTap: onPackages ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.newspaper,
            label: 'Новости',
            onTap: onNews ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.local_offer,
            label: 'Акции',
            onTap: onPromos ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.reviews,
            label: 'Отзывы',
            onTap: onReviews ?? () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          GradientActionButton(
            icon: Icons.info,
            label: 'О нас',
            onTap: onAbout ?? () => Navigator.pop(context),
          ),
          const Spacer(),

          // Затемняющий градиент только под copyright — для контраста
          Container(
            width: double.infinity,
            height: 70,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ],
                stops: [0.1, 1],
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: StrokeText(
                text: "Bavaria.kg © \n 2009-2025",
                fontSize: 15,
                strokeColor: Colors.black,
                textColor: Colors.grey,
                strokeWidth: 1.1,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
