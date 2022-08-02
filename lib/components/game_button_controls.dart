import 'package:anime_slide_puzzle/components/game_status.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PuzzleBoard curPuzzleBoardContext = context.read<PuzzleBoard>();

    return Column(
      children: [
        const GameStatus(),
        TextButton(
          onPressed: () {
            curPuzzleBoardContext.startGame();
          },
          child: (context.watch<PuzzleBoard>().isGameInProgress)
              ? const Text('Restart Game')
              : const Text('Start Game'),
        ),
        TextButton(
          onPressed: () {
            context.read<PuzzleBoard>().solvePuzzleWithAStar();
          },
          child: const Text('Solve'),
        ),
        TextButton(
          onPressed: () {
            curPuzzleBoardContext.toggleTileNumberVisibility();
          },
          child: (context.watch<PuzzleBoard>().currentTileOpacity == 0)
              ? const Text('Show Puzzle Number')
              : const Text('Hide Puzzle Number'),
        ),
      ],
    );
  }
}
