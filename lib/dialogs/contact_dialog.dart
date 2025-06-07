import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void showContactsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const ContactsDialog(),
  );
}

class ContactsDialog extends StatelessWidget {
  const ContactsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Оформление для круглых кнопок WhatsApp/Звонок
    final btnStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(12),
      backgroundColor: Colors.white,
      elevation: 5,
    );

    Widget contactRow({
      required String title,
      required String whatsapp,
      required String phone,
    }) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: btnStyle,
                onPressed: () async {
                  final uri = Uri.parse("https://wa.me/$whatsapp");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Icon(FontAwesomeIcons.whatsapp, size: 22, color: Colors.green),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: btnStyle,
                onPressed: () async {
                  final uri = Uri.parse("tel:+$phone");
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: const Icon(Icons.phone, size: 24, color: Colors.blueAccent),
              ),
            ],
          ),
        );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
      child: Container(
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
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "Контакты",
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
              const SizedBox(height: 20),

              // Сервис
              contactRow(
                title: "Сервис",
                whatsapp: "996555103333",
                phone: "996555103333",
              ),

              // Магазин
              contactRow(
                title: "Магазин",
                whatsapp: "996555343960",
                phone: "996555343960",
              ),

              // Авторазбор
              contactRow(
                title: "Авторазбор",
                whatsapp: "996554343960",
                phone: "996554343960",
              ),

              const SizedBox(height: 20),
              // Как к нам проехать
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 215, 0),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse('https://go.2gis.com/eFvmm');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.map, size: 22),
                label: const Text("Как к нам проехать"),
              ),
              const SizedBox(height: 8),

              // Instagram
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () async {
                  final uri = Uri.parse('https://www.instagram.com/bavaria.kg/');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
                label: const Text("Мы в Instagram"),
              ),
              const SizedBox(height: 10),

              // Кнопка закрыть
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Закрыть',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
