import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/show_hints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatefulWidget {
  const GameButtonControls(
      {Key? key, this.spaceBetween = 10, this.useColumn = false})
      : super(key: key);

  final double spaceBetween;
  final bool useColumn;

  @override
  State<GameButtonControls> createState() => _GameButtonControlsState();
}

class _GameButtonControlsState extends State<GameButtonControls> {
  Future<void> shuffleBoard() async {
    if (!mounted) return;
    context.read<GameTimer>().resetTimer();

    PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
    await puzzleBoard.startGame(3);

    if (!mounted) return;
    context.read<GameTimer>().startTimer();
  }

  List<Widget> _generateTextButtonControls(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();
    ShowHints showHints = context.watch<ShowHints>();

    return [
      TextButton(
        onPressed: (puzzleBoard.isLookingForSolution || puzzleBoard.isShuffling)
            ? null
            : () => shuffleBoard(),
        child: (puzzleBoard.isGameInProgress)
            ? const Text('Restart Game')
            : const Text('Start Game'),
      ),
      SizedBox(height: widget.spaceBetween, width: widget.spaceBetween),
      (!puzzleBoard.isGameInProgress || puzzleBoard.isShuffling)
          ? const SizedBox()
          : TextButton(
              onPressed: (puzzleBoard.isLookingForSolution)
                  ? null
                  : () => puzzleBoard.autoSolve(),
              child: const Text('Auto-Solve'),
            ),
      SizedBox(height: widget.spaceBetween, width: widget.spaceBetween),
      if (!context.read<AnimeThemeList>().isLoadingImage)
        TextButton(
          onPressed: () => showHints.toggleShowHints(),
          child: (showHints.isShowingHints)
              ? const Text('Hide Hints')
              : const Text('Show Hints'),
        ),
    ];
  }

  List<Widget> _generateElevatedButtonControls(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();
    ShowHints showHints = context.watch<ShowHints>();

    return [
      ElevatedButton(
        onPressed: (puzzleBoard.isLookingForSolution || puzzleBoard.isShuffling)
            ? null
            : () => shuffleBoard(),
        child: (puzzleBoard.isGameInProgress)
            ? const Text('Restart Game')
            : const Text('Start Game'),
      ),
      SizedBox(height: widget.spaceBetween, width: widget.spaceBetween),
      (!puzzleBoard.isGameInProgress || puzzleBoard.isShuffling)
          ? const SizedBox()
          : ElevatedButton(
              onPressed: (puzzleBoard.isLookingForSolution)
                  ? null
                  : () => puzzleBoard.autoSolve(),
              child: const Text('Auto-Solve'),
            ),
      SizedBox(height: widget.spaceBetween, width: widget.spaceBetween),
      if (!context.read<AnimeThemeList>().isLoadingImage)
        ElevatedButton(
          onPressed: () => showHints.toggleShowHints(),
          child: (showHints.isShowingHints)
              ? const Text('Hide Hints')
              : const Text('Show Hints'),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    AnimeTheme animeTheme = context.read<AnimeThemeList>().curAnimeTheme;

    return LayoutBuilder(builder: (context, constraints) {
      return (widget.useColumn || constraints.maxWidth < 340)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (animeTheme.name == 'jujutsu_kaisen')
                  ? _generateElevatedButtonControls(context)
                  : _generateTextButtonControls(context),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (animeTheme.name == 'jujutsu_kaisen')
                  ? _generateElevatedButtonControls(context)
                  : _generateTextButtonControls(context),
            );
    });
  }
}
