import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/countdown.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/custom_back_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board_reference_image.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_timer_text.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/number_of_moves.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/sized_hero_image.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
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

  @override
  Widget build(BuildContext context) {
    AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    AnimeTheme animeTheme = animeThemeList.curAnimeTheme;
    bool isShuffling = context
        .select<PuzzleBoard, bool>((puzzleBoard) => puzzleBoard.isShuffling);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(imagePath: animeTheme.puzzleBackgroundImagePath),
          const SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: CustomBackButton(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedHeroImage(
                          animeTheme: animeTheme,
                          height: (animeTheme.name == 'demon_slayer')
                              ? MediaQuery.of(context).size.height * .2
                              : null,
                          width: (animeTheme.name == 'demon_slayer')
                              ? null
                              : MediaQuery.of(context).size.width * .2,
                        ),
                        const GameBoardReferenceImage(width: 165, height: 165),
                        const GameButtonControls(),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (isShuffling)
                          ? const Countdown(textSize: 50)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                GameTimerText(),
                                Text(' | '),
                                NumberOfMoves(),
                              ],
                            ),
                      const SizedBox(height: 20),
                      GameBoard(
                        width: puzzleWidth,
                        height: puzzleHeight,
                        tilePadding: puzzlePadding,
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
