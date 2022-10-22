import 'package:anime_slide_puzzle/view/game_board/game_board_components/countdown.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_board_reference_image.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_button_controls.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_timer_text.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/number_of_moves.dart';
import 'package:anime_slide_puzzle/view/game_board/game_board_components/sized_hero_image.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/repository/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoardLayoutLarge extends StatelessWidget {
  const GameBoardLayoutLarge({
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

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedHeroImage(
                    animeTheme: animeTheme,
                    height: (animeTheme.name == 'demon_slayer')
                        ? MediaQuery.of(context).size.height * .3
                        : null,
                    width: (animeTheme.name == 'demon_slayer')
                        ? null
                        : MediaQuery.of(context).size.width * .2),
                const SizedBox(height: 100),
                (isShuffling)
                    ? const Countdown(textSize: 50)
                    : Column(
                        children: const [
                          GameTimerText(),
                          SizedBox(height: 20),
                          NumberOfMoves(),
                        ],
                      ),
              ],
            ),
            GameBoard(
              width: puzzleWidth,
              height: puzzleHeight,
              tilePadding: puzzlePadding,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Flexible(
                  flex: 2,
                  child: GameBoardReferenceImage(width: 200, height: 200),
                ),
                Flexible(
                  child: GameButtonControls(spaceBetween: 30, useColumn: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
