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
          const BackButton(),
          const Positioned(
            right: 0,
            child: ImageSelectionBar(),
          ),
        ],
      ),
    );
  }
}
