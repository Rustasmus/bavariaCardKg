import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/stroke_text.dart';
import 'dart:ui';

class NewsDialog extends StatefulWidget {
  final int initialIndex;
  const NewsDialog({super.key, required this.initialIndex});

  @override
  State<NewsDialog> createState() => _NewsDialogState();
}

class _NewsDialogState extends State<NewsDialog> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    // Позже вызовем, когда будет известна высота карточки
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Примерно: высота карточки + отступ
      double cardHeight = 165; // Задай по своей верстке
      _scrollController.animateTo(
        index * cardHeight,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 44),
      child: Stack(
        children: [
          // Фон и блюр
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/main_fon_grad.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(32)),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.black.withOpacity(0.15),
              ),
            ),
          ),
          // Основной контент
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey.withOpacity(0.48),
                  Colors.black.withOpacity(0.34),
                  Colors.blueGrey.shade800.withOpacity(0.25),
                ],
                stops: const [0, 0.7, 1],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 18),
                StrokeText(
                  text: "Новости и события",
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                  strokeColor: Colors.black,
                  strokeWidth: 2,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
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
                      // Автоскролл к нужной карточке, когда появятся данные
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollToIndex(widget.initialIndex);
                      });

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: news.length,
                        itemBuilder: (context, i) {
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
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildNewsCard(
                              context: context,
                              title: title,
                              description: description,
                              date: dateStr,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueGrey.withOpacity(0.22),
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Закрыть',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
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
    final cardWidth = screenWidth * 0.9 > 420 ? 420.0 : screenWidth * 0.9;

    return Center(
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 22, 88, 142), // Окантовка карточки
            width: 2.1,
          ),
          image: const DecorationImage(
            image: AssetImage('assets/images/main_fon.png'), // Фон для карточки
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.17),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            StrokeText(
              text: title,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              textColor: const Color.fromARGB(255, 255, 215, 0),
              strokeColor: Colors.black,
              strokeWidth: 1.5,
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 225, 225, 220),
                shadows: [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.black87,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blueAccent, size: 17),
                const SizedBox(width: 6),
                StrokeText(
                  text: date,
                  fontSize: 15.5,
                  textColor: Colors.blueAccent,
                  strokeColor: Colors.black,
                  strokeWidth: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showNewsDialog(BuildContext context, {required int initialIndex}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => NewsDialog(initialIndex: initialIndex),
  );
}
