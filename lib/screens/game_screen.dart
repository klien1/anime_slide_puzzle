import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/congratulations.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/custom_back_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_large.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_small.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_layout/game_board_layout_medium.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/show_hints.dart';
import 'package:anime_slide_puzzle/utils/responsive_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static String id = 'game_screen_id';

  static const double smallScreenPercentage = 0.65;
  static const double mediumScreenPercentage = 0.65;
  static const double largeScreenPercentage = 0.6;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    final AnimeTheme animeTheme = animeThemeList.curAnimeTheme;

    final numTiles = context.read<NumberPuzzleTiles>().currentNumberOfTiles;

    final gameProviders = [
      ChangeNotifierProvider<ShowHints>(create: (_) => ShowHints()),
      ChangeNotifierProvider<GameTimer>(create: (_) => GameTimer()),
      ChangeNotifierProvider<PuzzleBoard>(
        create: (_) => PuzzleBoard(numRowsOrColumns: numTiles),
      ),
    ];

    return MultiProvider(
      providers: gameProviders,
      child: Scaffold(
        body: Stack(children: [
          BackgroundImage(imagePath: animeTheme.puzzleBackgroundImagePath),
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: CustomBackButton(),
            ),
          ),
          ResponsiveLayout(
            mobile: (screenHeight < screenWidth)
                ? GameBoardLayoutSmall(
                    puzzleWidth: screenHeight * smallScreenPercentage,
                    puzzleHeight: screenHeight * smallScreenPercentage,
                    puzzlePadding: 5,
                  )
                : GameBoardLayoutSmall(
                    puzzleWidth: screenWidth * smallScreenPercentage,
                    puzzleHeight: screenWidth * smallScreenPercentage,
                    puzzlePadding: 5,
                  ),
            tablet: (screenHeight < screenWidth)
                ? GameBoardLayoutMedium(
                    puzzleWidth: screenHeight * mediumScreenPercentage,
                    puzzleHeight: screenHeight * mediumScreenPercentage,
                    puzzlePadding: 5,
                  )
                : GameBoardLayoutMedium(
                    puzzleWidth: screenWidth * mediumScreenPercentage,
                    puzzleHeight: screenWidth * mediumScreenPercentage,
                    puzzlePadding: 5,
                  ),
            web: (screenHeight < screenWidth)
                ? GameBoardLayoutLarge(
                    puzzleWidth: screenHeight * largeScreenPercentage,
                    puzzleHeight: screenHeight * largeScreenPercentage,
                    puzzlePadding: 5,
                  )
                : GameBoardLayoutLarge(
                    puzzleWidth: screenWidth * largeScreenPercentage,
                    puzzleHeight: screenWidth * largeScreenPercentage,
                    puzzlePadding: 5,
                  ),
          ),
          const Congratulations(),
        ]),
      ),
    );
  }
}
