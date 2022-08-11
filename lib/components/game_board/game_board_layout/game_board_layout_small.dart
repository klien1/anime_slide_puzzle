import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_button_controls.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_status.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/sized_hero_image.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
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
    AnimeThemeList animeThemeList = context.read<AnimeThemeList>();
    AnimeTheme animeTheme = animeThemeList.curAnimeTheme;

    return Scaffold(
      body: Stack(
        children: [
          BackgroundImage(imagePath: animeTheme.puzzleBackgroundImagePath),
          const SafeArea(child: BackButton()),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 50),
                Expanded(child: SizedHeroImage(animeTheme: animeTheme)),
                const Expanded(child: GameStatus()),
                GameBoard(
                  width: puzzleWidth,
                  height: puzzleHeight,
                  tilePadding: puzzlePadding,
                ),
                Expanded(
                  child: SizedBox(
                    width: puzzleWidth,
                    child: const GameButtonControls(spaceBetween: 10),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
