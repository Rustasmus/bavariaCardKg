import 'package:flutter/material.dart';

class BurDrawer extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onHome;
  final VoidCallback? onContacts;
  final VoidCallback? onNews;
  final VoidCallback? onOffers;
  final VoidCallback? onReviews;
  final VoidCallback? onAbout;
  final VoidCallback? onPackages;

  const BurDrawer({
    this.onLogin,
    this.onHome,
    this.onPackages,
    this.onContacts,
    this.onNews,
    this.onOffers,
    this.onReviews,
    this.onAbout,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Фон (carbon)
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/carbon_bra.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0.16),
        ),
        Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(28),
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
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      // Тень 1 — синяя, будто свет от фары
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
            _DrawerItem(
              icon: Icons.login,
              text: 'Вход',
              color: const Color.fromARGB(255, 255, 215, 0),
              onTap: onLogin ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.home,
              text: 'Домой',
              color:  const Color.fromARGB(255, 255, 215, 0),
              onTap: onHome ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.contacts,
              text: 'Контакты',
              color:  const Color.fromARGB(255, 255, 215, 0),
              onTap: onContacts ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.folder,
              text: 'Пакеты',
              color:   const Color.fromARGB(255, 255, 215, 0),
              onTap: onPackages ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.article,
              text: 'Новости',
              color:   const Color.fromARGB(255, 255, 215, 0),
              onTap: onNews ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.local_offer,
              text: 'Акции',
              color:  const Color.fromARGB(255, 255, 215, 0),
              onTap: onOffers ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.reviews,
              text: 'Отзывы',
              color:  const Color.fromARGB(255, 255, 215, 0),
              onTap: onReviews ?? () => Navigator.pop(context),
            ),
            _DrawerItem(
              icon: Icons.info,
              text: 'О нас',
              color:  const Color.fromARGB(255, 255, 215, 0),
              onTap: onAbout ?? () => Navigator.pop(context),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Text(
                "Bavaria.kg © \n 2009-2025",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _DrawerItem({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: color),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      hoverColor: Colors.blueGrey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    );
  }
}
