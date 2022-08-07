// import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
// import 'package:anime_slide_puzzle/components/image_selection_background.dart';
import 'package:anime_slide_puzzle/components/image_selection_bar.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
// import 'package:anime_slide_puzzle/screens/game_screen.dart';
// import 'package:anime_slide_puzzle/models/background_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
// import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';

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
            child: animeThemeList.getCurrentBackgroundImage(),
          ),
          const ImageSelectionBar(),
        ],
      ),
    );
  }
}
