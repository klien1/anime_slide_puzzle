import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key, this.spaceBetween = 10})
      : super(key: key);

  final double spaceBetween;

  List<Widget> generateTextButtonControls(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();

    return [
      SizedBox(height: spaceBetween),
      TextButton(
        onPressed: (puzzleBoard.isLookingForSolution)
            ? null
            : () {
                context.read<GameTimer>()
                  ..resetTimer()
                  ..startTimer();
                puzzleBoard.startGame();
              },
        child: (puzzleBoard.isGameInProgress)
            ? const Text('Restart Game')
            : const Text('Start Game'),
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      TextButton(
        onPressed: (puzzleBoard.isLookingForSolution)
            ? null
            : () => puzzleBoard.autoSolve(),
        child: const Text('Auto-Solve'),
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      if (!context.read<AnimeThemeList>().isLoadingImage)
        TextButton(
          onPressed: () => puzzleBoard.toggleTileNumberVisibility(),
          child: (puzzleBoard.currentTileOpacity == 0)
              ? const Text('Show Hints')
              : const Text('Hide Hints'),
        ),
    ];
  }

  List<Widget> generateElevatedButtonControls(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();

    return [
      SizedBox(height: spaceBetween),
      ElevatedButton(
        onPressed: (puzzleBoard.isLookingForSolution)
            ? null
            : () {
                context.read<GameTimer>()
                  ..resetTimer()
                  ..startTimer();
                puzzleBoard.startGame();
              },
        child: (puzzleBoard.isGameInProgress)
            ? const Text('Restart Game')
            : const Text('Start Game'),
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      ElevatedButton(
        onPressed: (puzzleBoard.isLookingForSolution)
            ? null
            : () => puzzleBoard.autoSolve(),
        child: const Text('Auto-Solve'),
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      if (!context.read<AnimeThemeList>().isLoadingImage)
        ElevatedButton(
          onPressed: () => puzzleBoard.toggleTileNumberVisibility(),
          child: (puzzleBoard.currentTileOpacity == 0)
              ? const Text('Show Hints')
              : const Text('Hide Hints'),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AnimeTheme animeTheme = context.read<AnimeThemeList>().curAnimeTheme;

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (animeTheme.name == 'jujutsu_kaisen')
            ? generateElevatedButtonControls(context)
            : generateTextButtonControls(context));
  }
}
