import 'package:anime_slide_puzzle/components/anime_slide_puzzle_title.dart';
import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_bar.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Positioned(
            top: 50,
            right: 250,
            child: AnimeSlidePuzzleTitle(),
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
