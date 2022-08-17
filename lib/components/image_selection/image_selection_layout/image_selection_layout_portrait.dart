import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/image_selection_bar.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ImageSelectionLayoutPortrait extends StatelessWidget {
  const ImageSelectionLayoutPortrait({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Stack(children: [
      AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: BackgroundImage(
          key: ValueKey(animeThemeList.curAnimeTheme.puzzleBackgroundImagePath),
          imagePath: animeThemeList.curPuzzleBackground,
          fit: BoxFit.fill,
        ),
      ),
      const SafeArea(child: BackButton()),
      const Align(alignment: Alignment.center, child: ImageSelectionBar()),
    ]);
  }
}
