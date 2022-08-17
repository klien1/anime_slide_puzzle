import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/image_selection_bar.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ImageSelectionLayoutLandscape extends StatelessWidget {
  const ImageSelectionLayoutLandscape({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: BackgroundImage(
            key: ValueKey(animeThemeList.curAnimeTheme.backgroundImagePath),
            imagePath: animeThemeList.curBackground,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor:
                      animeThemeList.curAnimeTheme.elevatedButtonPrimary),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new),
              label: const Text('Back'),
            ),
          ),
        ),
        const Positioned(right: 0, child: ImageSelectionBar()),
      ],
    );
  }
}
