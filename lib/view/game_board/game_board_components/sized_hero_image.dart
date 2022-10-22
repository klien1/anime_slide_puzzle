import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:flutter/material.dart';

class SizedHeroImage extends StatelessWidget {
  const SizedHeroImage(
      {Key? key, required this.animeTheme, this.height, this.width})
      : super(key: key);

  final AnimeTheme animeTheme;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Hero(
        tag: animeTheme.name,
        child: Image(
          image: AssetImage(animeTheme.logoImagePath),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
