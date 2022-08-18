import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class AutoSolveButton extends StatelessWidget {
  const AutoSolveButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Tuple3<bool, bool, bool> boardStatus =
        context.select<PuzzleBoard, Tuple3<bool, bool, bool>>(
      (puzzleBoard) => Tuple3(
        puzzleBoard.isLookingForSolution,
        puzzleBoard.isShuffling,
        puzzleBoard.isGameInProgress,
      ),
    );

    final bool isLookingForSolution = boardStatus.item1;
    final bool isShuffling = boardStatus.item2;
    final bool isGameInProgress = boardStatus.item3;

    return (!isGameInProgress || isShuffling)
        ? const SizedBox.shrink()
        : TextButton(
            onPressed: (isLookingForSolution)
                ? null
                : () => context.read<PuzzleBoard>().autoSolve(),
            child: const Text('Auto-Solve'),
          );
  }
}
