import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color strokeColor;
  final Color textColor;
  final double strokeWidth;
  final FontWeight fontWeight;

  const StrokeText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.strokeColor = Colors.blueGrey,
    this.textColor = Colors.white,
    this.strokeWidth = 6.5,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Stroke
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        // Fill
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
