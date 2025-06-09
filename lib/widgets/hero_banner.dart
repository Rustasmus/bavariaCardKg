import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroBanner extends StatefulWidget {
  const HeroBanner({super.key});

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _current = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bannerHeight = MediaQuery.of(context).size.width * 0.48;

    return SizedBox(
      height: bannerHeight,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('banners')
            .doc('main')
            .collection('slides')
            .orderBy('order')
            .snapshots(),
        builder: (context, snapshot) {
          // Показываем SkeletonLoader пока данные не подгрузились
          if (!snapshot.hasData) {
            return BannerSkeletonLoader(height: bannerHeight);
          }
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return BannerSkeletonLoader(height: bannerHeight, count: 1);
          }
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: docs.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, i) {
                  final data = docs[i].data() as Map<String, dynamic>;
                  final image = data['image'] as String? ?? '';
                  final title = data['title'] as String? ?? '';
                  final desc = data['desc'] as String? ?? '';
                  return _HeroBannerCard(
                    imageUrl: image,
                    title: title,
                    desc: desc,
                    height: bannerHeight,
                  );
                },
              ),
              // Индикаторы
              Positioned(
                bottom: 10,
                left: 0, right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(docs.length, (i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _current == i ? 18 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _current == i
                            ? Colors.amber
                            : Colors.amber.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class _HeroBannerCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String desc;
  final double height;

  const _HeroBannerCard({
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Фото на весь фон с кэшированием и Skeleton-лоадером
            if (imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: height,
                placeholder: (context, url) => BannerSkeletonLoader(height: height, count: 1),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 44),
                ),
                fadeInDuration: const Duration(milliseconds: 380),
                fadeOutDuration: const Duration(milliseconds: 160),
              )
            else
              Container(
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 56, color: Colors.white70),
              ),
            // затемнение
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.46),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.75],
                ),
              ),
            ),
            // Контент поверх фото
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.black, blurRadius: 10, offset: Offset(1, 2)),
                      ],
                    ),
                  ),
                  if (desc.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(color: Colors.black, blurRadius: 8, offset: Offset(1, 1)),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Skeleton Loader ====================

class BannerSkeletonLoader extends StatelessWidget {
  final double height;
  final int count;
  const BannerSkeletonLoader({super.key, required this.height, this.count = 2});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) => _AnimatedSkeletonBox(height: height),
      ),
    );
  }
}

class _AnimatedSkeletonBox extends StatefulWidget {
  final double height;
  const _AnimatedSkeletonBox({required this.height});

  @override
  State<_AnimatedSkeletonBox> createState() => __AnimatedSkeletonBoxState();
}

class __AnimatedSkeletonBoxState extends State<_AnimatedSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1300))
      ..repeat(reverse: true);
    _shimmer = Tween<double>(begin: 0.82, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (context, child) => Opacity(
        opacity: _shimmer.value,
        child: child,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.88,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    );
  }
}
