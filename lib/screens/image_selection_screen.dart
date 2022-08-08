import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection_bar.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ImageSelectionScreen extends StatelessWidget {
  const ImageSelectionScreen({Key? key}) : super(key: key);

  static const String id = 'image_selection_id';

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Scaffold(
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: BackgroundImage(
              key: UniqueKey(),
              imagePath: animeThemeList.curBackground,
            ),
          ),
          // FlipBackgroundImage(
          //   backgroundImagePath: animeThemeList.curBackground,
          //   flipImage: animeThemeList.curAnimeTheme.flipImage ?? true,
          // ),
          // Transform(
          //   alignment: Alignment.center,
          //   transform: Matrix4.rotationY(pi),
          //   child: AnimatedSwitcher(
          //     duration: const Duration(seconds: 1),
          //     child: BackgroundImage(
          //       key: UniqueKey(),
          //       imagePath: animeThemeList.curBackground,
          //     ),
          //   ),
          // ),
          const Align(
            alignment: Alignment.topCenter,
            child: Text(
              'Anime Slide Puzzle',
              textAlign: TextAlign.center,
            ),
          ),
          const Positioned(
            right: 0,
            child: ImageSelectionBar(),
          ),
        ],
      ),
    );
  }
}

class FlipBackgroundImage extends StatelessWidget {
  const FlipBackgroundImage({
    Key? key,
    required this.backgroundImagePath,
    required this.flipImage,
  }) : super(key: key);

  final String backgroundImagePath;
  final bool flipImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: (flipImage)
          ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(pi),
              child: BackgroundImage(
                key: UniqueKey(),
                imagePath: backgroundImagePath,
              ),
            )
          : BackgroundImage(
              key: UniqueKey(),
              imagePath: backgroundImagePath,
            ),
    );
    // : AnimatedSwitcher(
    //     duration: const Duration(seconds: 1),
    //     child: BackgroundImage(
    //       key: UniqueKey(),
    //       imagePath: backgroundImagePath,
    //     ),
    //   );
  }
}
