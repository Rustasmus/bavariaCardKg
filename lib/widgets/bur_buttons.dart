import 'package:flutter/material.dart';

class GradientActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color mainColor;
  final Color lightCenterColor;
  final LinearGradient? gradient;

  const GradientActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.mainColor = const Color.fromARGB(255, 22, 88, 142),
    this.lightCenterColor = const Color.fromARGB(255, 77, 163, 229),
    this.gradient, // добавлен параметр
  }) : super(key: key);

  @override
  State<GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<GradientActionButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0;
    });
  }

  void _onTapCancel() {
    setState(() {
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeOutBack,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            bottomLeft: Radius.circular(28),
          ),
          onTap: widget.onTap,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Container(
            height: 56,
            width: 280,
            padding: const EdgeInsets.only(left: 10, right: 22),
            decoration: BoxDecoration(
              gradient: widget.gradient ??
                  LinearGradient(
                    colors: [
                      widget.mainColor,
                      widget.lightCenterColor,
                      widget.mainColor
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0, 0.5, 2],
                  ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                bottomLeft: Radius.circular(28),
                topRight: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.mainColor.withOpacity(0.13),
                  blurRadius: 8,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.32),
                      width: 1.7,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: 0.2,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 2,
                        offset: Offset(1, 1),
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
