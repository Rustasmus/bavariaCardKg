import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/auth_service.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Map<String, dynamic>? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.currentUser;
    if (user != null) {
      final data = await authService.fetchUserProfile(user.uid);
      setState(() {
        userProfile = data;
        isLoading = false;
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(199, 232, 238, 235),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Верхняя панель
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // Вот тут используется Имя и Отчество!
                          '${userProfile?['firstName'] ?? ''} ${userProfile?['middleName'] ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () => authService.logout(),
                          child: const Text('Выйти'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // QR-код
                  QrImageView(
                    data: user?.uid ?? "unknown",
                    size: 160.0,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  // Кнопки
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          buildButtonRow(
                            context,
                            "WhatsApp Сервис",
                            "Позвонить Сервис",
                            links,
                          ),
                          const SizedBox(height: 10),
                          buildButtonRow(
                            context,
                            "WhatsApp Магазин",
                            "Позвонить Магазин",
                            links,
                          ),
                          const SizedBox(height: 10),
                          buildButtonRow(
                            context,
                            "WhatsApp Авторазбор",
                            "Позвонить Авторазбор",
                            links,
                          ),
                          const SizedBox(height: 20),
                          // Остальные кнопки
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
                                      padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget buildButtonRow(BuildContext context, String whatsappKey, String phoneKey, Map<String, String> links) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(links[whatsappKey]!),
            icon: const FaIcon(FontAwesomeIcons.whatsapp),
            label: Text(whatsappKey.split(" ").last),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _launchURL(links[phoneKey]!),
            icon: const Icon(Icons.phone),
            label: Text(phoneKey.split(" ").last),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
