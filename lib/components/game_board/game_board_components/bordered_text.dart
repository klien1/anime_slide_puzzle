import 'package:flutter/material.dart';

class BorderedText extends StatelessWidget {
  const BorderedText({
    Key? key,
    required this.text,
    required this.strokeWidth,
    required this.strokeColor,
    required this.textColor,
    this.style = const TextStyle(),
  }) : super(key: key);

  final String text;
  final double strokeWidth;
  final Color strokeColor;
  final Color textColor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ),
        ),
        Text(
          text,
          style: style.copyWith(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
