import 'package:anime_slide_puzzle/components/game_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();

    return Column(
      children: [
        const GameStatus(),
        TextButton(
          onPressed: (puzzleBoard.isLookingForSolution)
              ? null
              : () => puzzleBoard.startGame(),
          child: (puzzleBoard.isGameInProgress)
              ? const Text('Restart Game')
              : const Text('Start Game'),
        ),
        // TextButton(
        //   onPressed: (curPuzzleBoardContext.isLookingForSolution)
        //       ? null
        //       : () {
        //           context.read<PuzzleBoard>().solvePuzzleWithAStar();
        //         },
        //   child: const Text('Solve with A Star'),
        // ),
        TextButton(
          onPressed: (puzzleBoard.isLookingForSolution)
              ? null
              : () {
                  puzzleBoard.autoSolve();
                  // context.read<PuzzleBoard>().solvePuzzleWithIDAStar();
                },
          child: const Text('Auto-Solve'),
        ),
        TextButton(
          onPressed: () {
            // puzzleBoard.autoSolve();
            // AutoSolver(puzzleBoard: puzzleBoard).solve();
            puzzleBoard.toggleTileNumberVisibility();
          },
          child: (puzzleBoard.currentTileOpacity == 0)
              ? const Text('Show Hints')
              : const Text('Hide Hints'),
        ),
      ],
    );
  }
}
