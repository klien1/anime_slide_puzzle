import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/custom_back_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_status.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/sized_hero_image.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoardLayoutMedium extends StatelessWidget {
  const GameBoardLayoutMedium({
    Key? key,
    required this.puzzleWidth,
    required this.puzzleHeight,
    required this.puzzlePadding,
  }) : super(key: key);

  final double puzzleWidth;
  final double puzzleHeight;
  final double puzzlePadding;

  void reset() {}

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    AnimeTheme animeTheme = animeThemeList.curAnimeTheme;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(imagePath: animeTheme.puzzleBackgroundImagePath),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: CustomBackButton(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            flex: 2,
                            child: SizedHeroImage(animeTheme: animeTheme),
                          ),
                          const Expanded(flex: 2, child: GameStatus()),
                          const Expanded(
                            flex: 2,
                            child: GameButtonControls(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * .025,
                      left: MediaQuery.of(context).size.width * .01,
                    ),
                    child: GameBoard(
                      width: puzzleWidth,
                      height: puzzleHeight,
                      tilePadding: puzzlePadding,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
