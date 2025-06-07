import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'auth_gate.dart'; // Импортируй свой AuthGate

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgScaleController;
  late final Animation<double> _bgScaleAnimation;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _playIntro();

    _bgScaleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _bgScaleAnimation = Tween<double>(begin: 1.0, end: 1.16).animate(
      CurvedAnimation(
        parent: _bgScaleController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _bgScaleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AuthGate()),
        );
      }
    });
  }

  Future<void> _playIntro() async {
    await _player.play(AssetSource('sounds/intro.mp3'));
  }

  @override
  void dispose() {
    _bgScaleController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _bgScaleAnimation.value,
          child: child,
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/carbon_fiber.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
