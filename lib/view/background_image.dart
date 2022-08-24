import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    Key? key,
    required this.imagePath,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  final String imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(imagePath), fit: fit),
          ),
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
