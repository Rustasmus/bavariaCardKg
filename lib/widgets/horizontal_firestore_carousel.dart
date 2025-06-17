import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorizontalFirestoreCarousel extends StatelessWidget {
  final String collectionPath;
  final String titleField;
  final String descField;
  final String metaField;
  final bool isDate;
  final String emptyMessage;
  final void Function(Map<String, dynamic> data, int index)? onCardTap;

  const HorizontalFirestoreCarousel({
    super.key,
    required this.collectionPath,
    required this.titleField,
    required this.descField,
    required this.metaField,
    this.isDate = false,
    this.emptyMessage = "Нет данных",
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double carouselHeight, cardWidth, cardHeight;
    if (screenWidth <= 400) {
      carouselHeight = 120;
      cardWidth = 170;
      cardHeight = 120;
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
        future: FirebaseFirestore.instance
            .collection(collectionPath)
            .orderBy(isDate ? metaField : 'title', descending: isDate)
            .limit(8)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(18.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                emptyMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'OpenSans',
                ),
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
                metaString =
                    "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
              } else {
                metaString = (meta ?? '').toString();
              }
              Widget card = _AnimatedFadeIn(
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
              // Оборачиваем в GestureDetector если onCardTap задан
              if (onCardTap != null) {
                card = GestureDetector(
                  onTap: () => onCardTap!(data, i),
                  child: card,
                );
              }
              return card;
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
          image: AssetImage('assets/images/main_fon.png'),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Color.fromARGB(255, 22, 88, 142),
          width: 2.0,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(22),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 1,
                    color: Colors.black,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  meta,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 3,
                        color: Colors.black,
                        offset: Offset(0.5, 1),
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
