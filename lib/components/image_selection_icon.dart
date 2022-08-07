import 'package:flutter/material.dart';

class ImageSelectionIcon extends StatelessWidget {
  const ImageSelectionIcon({
    Key? key,
    required this.imagePath,
    required this.isSelected,
    required this.index,
  }) : super(key: key);

  final String imagePath;
  final bool isSelected;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (isSelected)
          ? Colors.black.withOpacity(.25)
          : Colors.black.withOpacity(0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Hero(
          tag: 'anime_photo$index',
          child: Image(
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}
