import 'package:anime_slide_puzzle/components/game_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleBoard curPuzzleBoardContext = context.watch<PuzzleBoard>();

    return Column(
      children: [
        const GameStatus(),
        TextButton(
          onPressed: (curPuzzleBoardContext.isLookingForSolution)
              ? null
              : () => curPuzzleBoardContext.startGame(),
          child: (curPuzzleBoardContext.isGameInProgress)
              ? const Text('Restart Game')
              : const Text('Start Game'),
        ),
        TextButton(
          onPressed: (curPuzzleBoardContext.isLookingForSolution)
              ? null
              : () {
                  context.read<PuzzleBoard>().solvePuzzleWithAStar();
                },
          child: const Text('Solve with A Star'),
        ),
        TextButton(
          onPressed: (curPuzzleBoardContext.isLookingForSolution)
              ? null
              : () {
                  context.read<PuzzleBoard>().solvePuzzleWithIDAStar();
                },
          child: const Text('Solve with IDA star'),
        ),
        TextButton(
          onPressed: () {
            curPuzzleBoardContext.toggleTileNumberVisibility();
          },
          child: (curPuzzleBoardContext.currentTileOpacity == 0)
              ? const Text('Show Puzzle Number')
              : const Text('Hide Puzzle Number'),
        ),
      ],
    );
  }
}
