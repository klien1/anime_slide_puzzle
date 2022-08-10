import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({
    Key? key,
    this.alignRow = true,
    this.spaceBetween = 15,
  }) : super(key: key);

  final bool alignRow;
  final double spaceBetween;

  List<Widget> generateButtonControls(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();

    return [
      SizedBox(height: spaceBetween),
      SizedBox(
        width: 125,
        child: ElevatedButton(
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
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      SizedBox(
        width: 125,
        child: ElevatedButton(
          onPressed: (puzzleBoard.isLookingForSolution)
              ? null
              : () => puzzleBoard.autoSolve(),
          child: const Text('Auto-Solve'),
        ),
      ),
      SizedBox(height: spaceBetween, width: spaceBetween),
      SizedBox(
        width: 125,
        child: ElevatedButton(
          onPressed: () => puzzleBoard.toggleTileNumberVisibility(),
          child: (puzzleBoard.currentTileOpacity == 0)
              ? const Text('Show Hints')
              : const Text('Hide Hints'),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return (alignRow)
        ? Row(children: generateButtonControls(context))
        : Column(children: generateButtonControls(context));
  }
}
