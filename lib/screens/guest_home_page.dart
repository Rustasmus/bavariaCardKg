import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../widgets/bur_drawer.dart';
import '../dialogs/login_dialog.dart';
import '../dialogs/contact_dialog.dart';
import '../widgets/animated_logo_f.dart';
import '../dialogs/work_packages_page.dart';
import '../dialogs/news.dart';
import '../dialogs/promos.dart';

class GuestHomePage extends StatelessWidget {
  const GuestHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      drawer: SizedBox(
        width: width * 0.75,
        child: BurDrawer(
            onLogin: () {
              showDialog(
                context: context,
                builder: (context) => const LoginDialog(),
              );
            },
            onContacts: () => showContactsDialog(context),
            onPackages: () => showWorkPackageDialog(context),
            onNews: () => showNewsDialog(context),
            onPromos: () => showPromosDialog(context),
            ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: const Color.fromARGB(255, 255, 215, 0),
              size: 32,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
            splashRadius: 26,
          ),
        ),
        title: const LogoShine(
          size: 300,
          assetPath: 'assets/images/logoF.png',
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Фон
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/carbon_back.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.1),
                  BlendMode.lighten,
                ),
              ),
            ),
          ),
          // Контент
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 18),
                Text(
                  "В разработке!",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent.shade700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BmwButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _BmwButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),
        icon: Icon(icon, size: 24),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}
