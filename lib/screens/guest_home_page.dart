import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../dialogs/login_dialog.dart';
import '../widgets/pulsating_logo.dart';

class GuestHomePage extends StatelessWidget {
  final String name = "Bavaria.kg";
  final String description = "Автосервис BMW";

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

  GuestHomePage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Не удалось открыть $url';
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
                  child: const Text('Вход'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const PulsatingLogo(),
            const SizedBox(height: 2),
            Text(name, style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(fontSize: 16, color: Colors.black)),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _buildButtonRows(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtonRows() {
    List<List<String>> groups = [
      ["WhatsApp Сервис", "Позвонить Сервис"],
      ["WhatsApp Магазин", "Позвонить Магазин"],
      ["WhatsApp Авторазбор", "Позвонить Авторазбор"]
    ];

    return [
      for (var group in groups)
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: group.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(links[key]!),
                    icon: key.contains("WhatsApp")
                        ? const FaIcon(FontAwesomeIcons.whatsapp)
                        : const Icon(Icons.phone),
                    label: Text(key.split(' ').last),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      const SizedBox(height: 20),
      Expanded(
        child: ListView(
          children: links.entries
              .where((entry) => !entry.key.contains("WhatsApp") && !entry.key.contains("Позвонить"))
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
      )
    ];
  }
}
