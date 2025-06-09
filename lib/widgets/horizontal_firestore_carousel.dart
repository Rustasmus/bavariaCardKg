import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorizontalFirestoreCarousel extends StatelessWidget {
  final String collectionPath;
  final String titleField;
  final String descField;
  final String metaField; // price, date или др.
  final bool isDate;
  final String emptyMessage;

  const HorizontalFirestoreCarousel({
    super.key,
    required this.collectionPath,
    required this.titleField,
    required this.descField,
    required this.metaField,
    this.isDate = false,
    this.emptyMessage = "Нет данных",
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double carouselHeight, cardWidth, cardHeight;
    if (screenWidth <= 400) {
      carouselHeight = 88;
      cardWidth = 160;
      cardHeight = 88;
    } else if (screenWidth <= 500) {
      carouselHeight = 105;
      cardWidth = 200;
      cardHeight = 105;
    } else {
      carouselHeight = 120;
      cardWidth = 240;
      cardHeight = 120;
    }

    return SizedBox(
      height: carouselHeight,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection(collectionPath)
            .orderBy(isDate ? metaField : 'title', descending: isDate)
            .limit(8).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Padding(
              padding: EdgeInsets.all(18.0),
              child: CircularProgressIndicator(),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                emptyMessage,
                style: const TextStyle(color: Colors.white70, fontSize: 17),
              ),
            );
          }
          final cards = snapshot.data!.docs;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, i) {
              final data = cards[i].data() as Map<String, dynamic>;
              final title = (data[titleField] ?? '').toString();
              final description = (data[descField] ?? '').toString();
              final meta = data[metaField];
              String metaString = '';
              if (isDate && meta is Timestamp) {
                final dt = meta.toDate();
                metaString = "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
              } else {
                metaString = (meta ?? '').toString();
              }
              return _AnimatedFadeIn(
                child: _CarouselCard(
                  title: title,
                  description: description,
                  meta: metaString,
                  color: isDate
                      ? Colors.blueGrey.withOpacity(0.65)
                      : const Color.fromARGB(255, 58, 200, 239).withOpacity(0.35),
                  width: cardWidth,
                  height: cardHeight,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final String title;
  final String description;
  final String meta;
  final Color color;
  final double width;
  final double height;

  const _CarouselCard({
    required this.title,
    required this.description,
    required this.meta,
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        image: const DecorationImage(
          image: AssetImage('assets/images/carbon_back.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 215, 0),
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(0, 0),
                    ),
                  ],
                )),
            const SizedBox(height: 3),
            Text(description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color.fromARGB(255, 225, 225, 220),
                  shadows: [
                    Shadow(
                      blurRadius: 1,
                      color: Colors.black,
                      offset: Offset(0, 1),
                    ),
                  ],
                )),
            const Spacer(),
            Row(
              children: [
                Text(
                  meta,
                  style: const TextStyle(
                    fontSize: 12,
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
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.white54),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFadeIn extends StatefulWidget {
  final Widget child;
  const _AnimatedFadeIn({required this.child});
  @override
  State<_AnimatedFadeIn> createState() => _AnimatedFadeInState();
}

class _AnimatedFadeInState extends State<_AnimatedFadeIn> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slide = Tween<Offset>(begin: const Offset(0.13, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}
