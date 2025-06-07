import 'package:flutter/material.dart';

class LogoShine extends StatefulWidget {
  final double size;
  final String assetPath;

  const LogoShine({super.key, this.size = 54, required this.assetPath});

  @override
  State<LogoShine> createState() => _LogoShineState();
}

class _LogoShineState extends State<LogoShine> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Делаем градиент длиннее по X, чтобы shine уходил далеко за лого
        final double progress = _controller.value;
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                const Color.fromARGB(255, 192, 192, 192).withOpacity(0.90),
                Colors.transparent,
              ],
              stops: const [0.38, 0.5, 0.62],
              begin: Alignment(-5.0 + 4.0 * progress, -2.0 + 4.0 * progress),   // ← Диагональ
              end: Alignment(1.0 + 4.0 * progress, 2.0 + 4.0 * progress),       // ← Диагональ
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Image.asset(
        widget.assetPath,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
      ),
    );
  }
}
