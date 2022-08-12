import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({Key? key, this.imagePath, this.fit = BoxFit.cover})
      : super(key: key);

  final String? imagePath;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    try {
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath!),
              fit: fit,
            ),
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }
}
// 'images/jujutsu_kaisen_background2_no_characters.png'),
// 'images/demon_slayer_background_no_characters2.png'),
// 'images/jujutsu_kaisen_background2_no_characters.png'),
// source: https://wall.alphacoders.com/big.php?i=1143485
// image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
// image: AssetImage('images/demon_slayer_background.jpg'),
// source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
// image: AssetImage('images/spy-x-family-background2.jpg'),
// source: https://wall.alphacoders.com/big.php?i=1227567

// spy bg 3
// source: https://popgeeks.com/spy-x-family-premieres-on-crunchyroll-april-9/
