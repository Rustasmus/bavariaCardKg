import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewsDialog extends StatelessWidget {
  const NewsDialog({super.key});

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
                  "Новости и события",
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
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('workmans')
                      .doc('newsyvttPHBhpwZZlEWNxuHD')
                      .collection('news')
                      .orderBy('date', descending: true)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text(
                        "Новостей пока нет",
                        style: TextStyle(color: Colors.white70, fontSize: 17),
                      );
                    }
                    final news = snapshot.data!.docs;
                    return Column(
                      children: List.generate(news.length, (i) {
                        final data = news[i].data() as Map<String, dynamic>;
                        final title = (data['title'] ?? '').toString();
                        final description = (data['description'] ?? '').toString();
                        final dateValue = data['date'];
                        String dateStr = '';
                        if (dateValue is Timestamp) {
                          final dt = dateValue.toDate();
                          dateStr = "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
                        } else if (dateValue is String) {
                          dateStr = dateValue;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14.0),
                          child: _buildNewsCard(
                            context: context,
                            title: title,
                            description: description,
                            date: dateStr,
                          ),
                        );
                      }),
                    );
                  },
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

  static Widget _buildNewsCard({
    required BuildContext context,
    required String title,
    required String description,
    required String date,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9 > 380 ? 380.0 : screenWidth * 0.9;

    return Center(
      child: SizedBox(
        width: cardWidth,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            image: const DecorationImage(
              image: AssetImage('assets/images/carbon_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color:  Colors.blueGrey.withOpacity(0.20),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 215, 0),
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.black54,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 225, 225, 220),
                    shadows: [
                      Shadow(
                        blurRadius: 1,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent,
                    shadows: [
                      Shadow(
                        blurRadius: 1,
                        color: Colors.black,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showNewsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => const NewsDialog(),
  );
}
