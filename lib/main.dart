import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dialogs/login_dialog.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // инициализация Firebase
  runApp(const BavariaApp());
}

class BavariaApp extends StatelessWidget {
  const BavariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bavaria.kg',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String name = "Bavaria.kg";
  final String description = "Автосервис BMW";
  final String logoUrl = "logo.png";

  final Map<String, String> links = {
    "WhatsApp Сервис": "https://wa.me/996555103333",
    "WhatsApp Магазин": "https://wa.me/996555343960",
    "WhatsApp Авторазбор": "https://wa.me/996554343960",
    "Instagram": "https://instagram.com/bavaria.kg",
    "Позвонить Сервис": "tel:+996555103333",
    "Позвонить Магазин": "tel:+996555343960",
    "Позвонить Авторазбор": "tel:+996554343960",
    "Мы в 2GIS": "https://go.2gis.com/12L50",
    "Запчасти в наличии": "https://bavaria-bishkek.ru/"
  };

  HomePage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(199, 232, 238, 235),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 16),
                child: ElevatedButton(
                  onPressed: () => showLoginDialog(context),
                  child: Text('Вход'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            PulsatingLogo(),
            const SizedBox(height: 2),
            Text(name, style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 1 ряд кнопок
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["WhatsApp Сервис"]!),
                            icon: FaIcon(FontAwesomeIcons.whatsapp),
                            label: Text("Сервис"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["Позвонить Сервис"]!),
                            icon: Icon(Icons.phone),
                            label: Text("Сервис"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 2 ряд кнопок
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["WhatsApp Магазин"]!),
                            icon: FaIcon(FontAwesomeIcons.whatsapp),
                            label: Text("Магазин"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["Позвонить Магазин"]!),
                            icon: Icon(Icons.phone),
                            label: Text("Магазин"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // 3 ряд кнопок
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["WhatsApp Авторазбор"]!),
                            icon: FaIcon(FontAwesomeIcons.whatsapp),
                            label: Text("Авторазбор"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _launchURL(links["Позвонить Авторазбор"]!),
                            icon: Icon(Icons.phone),
                            label: Text("Авторазбор"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Остальные кнопки в списке с прокруткой
                    Expanded(
                      child: ListView(
                        children: links.entries
                            .where((entry) =>
                                ![
                                  "WhatsApp Сервис",
                                  "Позвонить Сервис",
                                  "WhatsApp Магазин",
                                  "Позвонить Магазин",
                                  "WhatsApp Авторазбор",
                                  "Позвонить Авторазбор",
                                ].contains(entry.key))
                            .map((entry) {
                          IconData icon;
                          switch (entry.key) {
                            case 'Instagram':
                              icon = FontAwesomeIcons.instagram;
                              break;
                            case 'Мы в 2GIS':
                              icon = Icons.location_on;
                              break;
                            default:
                              icon = Icons.link;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton.icon(
                              onPressed: () => _launchURL(entry.value),
                              icon: FaIcon(icon),
                              label: Text(entry.key),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PulsatingLogo extends StatefulWidget {
  const PulsatingLogo({super.key});

  @override
  _PulsatingLogoState createState() => _PulsatingLogoState();
}

class _PulsatingLogoState extends State<PulsatingLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage('assets/images/logo.png'),
      ),
    );
  }
}
