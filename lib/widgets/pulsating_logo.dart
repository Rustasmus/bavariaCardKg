import 'package:flutter/material.dart';

class PulsatingLogo extends StatefulWidget {
  const PulsatingLogo({super.key});

  @override
  State<PulsatingLogo> createState() => _PulsatingLogoState();
}

class _PulsatingLogoState extends State<PulsatingLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
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
        backgroundImage: const AssetImage('assets/images/logo.png'),
      ),
    );
  }
}
