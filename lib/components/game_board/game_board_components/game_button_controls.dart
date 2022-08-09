import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();

    return Row(
      children: [
        const SizedBox(height: 15),
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
        const SizedBox(height: 15, width: 15),
        ElevatedButton(
          onPressed: (puzzleBoard.isLookingForSolution)
              ? null
              : () => puzzleBoard.autoSolve(),
          child: const Text('Auto-Solve'),
        ),
        const SizedBox(height: 15, width: 15),
        ElevatedButton(
          onPressed: () => puzzleBoard.toggleTileNumberVisibility(),
          child: (puzzleBoard.currentTileOpacity == 0)
              ? const Text('Show Hints')
              : const Text('Hide Hints'),
        ),
      ],
    );
  }
}
