import 'package:flutter/material.dart';

class WorkPackageDialog extends StatelessWidget {
  const WorkPackageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/carbon_bra.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.withOpacity(0.42),
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Пакеты услуг и запчастей",
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
                _buildPackageCard(
                  title: 'Пакет «ТО BMW»',
                  description:
                      'Включает замену масла, фильтров, диагностику ходовой и компьютерную диагностику.',
                  price: 'от 9 900 c',
                ),
                const SizedBox(height: 14),
                _buildPackageCard(
                  title: 'Пакет «Тормозная система»',
                  description:
                      'Замена колодок, дисков, проверка суппортов и уровня жидкости.',
                  price: 'от 7 500 c',
                ),
                const SizedBox(height: 14),
                _buildPackageCard(
                  title: 'Пакет «Ремонт подвески»',
                  description:
                      'Включает замену амортизаторов, стоек, рычагов и диагностику подвески.',
                  price: 'от 12 000 c',
                ),
                const SizedBox(height: 14),
                _buildPackageCard(
                  title: 'Пакет «Запчасти BMW»',
                  description:
                      'Оригинальные и аналоговые запчасти со склада и под заказ. Гарантия, быстрая доставка.',
                  price: 'по запросу',
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Закрыть',
                    style: TextStyle(color: Colors.white70, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildPackageCard({
    required String title,
    required String description,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
          const SizedBox(height: 7),
          Text(description, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 12),
          Text(price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent,
              )),
        ],
      ),
    );
  }
}

// === Вот это обязательно! ===
void showWorkPackageDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const WorkPackageDialog(),
  );
}
