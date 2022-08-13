import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/circle_transition_button.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/image_selection_icon.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// source: https://wall.alphacoders.com/big.php?i=1143485
// image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
// image: AssetImage('images/demon_slayer_background.jpg'),
// source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
// image: AssetImage('images/spy-x-family-background2.jpg'),
// source: https://wall.alphacoders.com/big.php?i=1227567

class ImageSelectionBar extends StatefulWidget {
  const ImageSelectionBar({Key? key}) : super(key: key);

  @override
  State<ImageSelectionBar> createState() => _ImageSelectionBarState();
}

class _ImageSelectionBarState extends State<ImageSelectionBar> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _preloadImages();
  }

  void _preloadImages() {
    if (!mounted) return;
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    for (int i = 0; i < animeThemeList.listLength; ++i) {
      if (!mounted) break;
      precacheImage(
        AssetImage(animeThemeList.getAnimeThemeAtIndex(i).backgroundImagePath),
        context,
      );
      if (!mounted) break;
      precacheImage(
        AssetImage(
            animeThemeList.getAnimeThemeAtIndex(i).puzzleBackgroundImagePath!),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 40,
        vertical: screenHeight * .05,
      ),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      width: 200,
      height: screenHeight * .9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < animeThemeList.listLength; ++i)
            Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: (i == animeThemeList.curIndex)
                    ? null
                    : () => animeThemeList.changeTheme(i),
                child: ImageSelectionIcon(
                  imagePath:
                      animeThemeList.getAnimeThemeAtIndex(i).logoImagePath,
                  isSelected: (i == animeThemeList.curIndex) ? true : false,
                  themeName: animeThemeList.getAnimeThemeAtIndex(i).name,
                ),
              ),
            ),
          const SizedBox(height: 10),
          const Expanded(
              child: SelectBoardSize(
                  minNumRowsOrColumns: 3, maxNumRowsOrColumns: 5)),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const CircleTransitionButton(
              destinationScreen: GameScreen(),
              buttonText: 'Go to Puzzle',
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
