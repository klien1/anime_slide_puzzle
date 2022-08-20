import 'package:anime_slide_puzzle/components/game_board/game_board_components/countdown.dart';
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

class GameBoardLayoutSmall extends StatelessWidget {
  const GameBoardLayoutSmall({
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
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    final AnimeTheme animeTheme = animeThemeList.curAnimeTheme;
    final bool isShuffling = context
        .select<PuzzleBoard, bool>((puzzleBoard) => puzzleBoard.isShuffling);

    final double screenHeightThreshold =
        MediaQuery.of(context).size.height * .5;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20),
          Flexible(
            child: SizedHeroImage(
              animeTheme: animeTheme,
              width: (animeTheme.name == 'spy_x_family')
                  ? MediaQuery.of(context).size.width * .8
                  : null,
              height: (animeTheme.name == 'demon_slayer')
                  ? MediaQuery.of(context).size.height * .3
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .42,
                child: (isShuffling)
                    ? const Padding(
                        padding: EdgeInsets.only(left: 80),
                        child: Countdown(textSize: 50),
                      )
                    : Column(
                        children: const [
                          GameTimerText(),
                          SizedBox(height: 10),
                          NumberOfMoves(),
                        ],
                      ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: GameBoardReferenceImage(height: 100, width: 100),
              )
            ],
          ),
          const SizedBox(height: 20),
          GameBoard(
            width: (puzzleHeight > screenHeightThreshold)
                ? screenHeightThreshold
                : puzzleWidth,
            height: (puzzleHeight > screenHeightThreshold)
                ? screenHeightThreshold
                : puzzleHeight,
            tilePadding: puzzlePadding,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 25, top: 15),
            child: GameButtonControls(),
          ),
        ],
      ),
    );
  }
}
