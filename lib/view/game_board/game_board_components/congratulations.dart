import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Congratulations extends StatelessWidget {
  const Congratulations({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleBoard, bool>(
        selector: (_, puzzleBoard) => puzzleBoard.isPuzzleCompleted,
        builder: (_, isPuzzleCompleted, child) {
          if (isPuzzleCompleted) {
            Future.delayed(
              Duration.zero,
              () => showDialog(
                context: context,
                builder: (_) => _CongratulationsDialog(
                  totalTime: context.read<GameTimer>().elapsedTime,
                  numMoves: context.read<PuzzleBoard>().numberOfMoves,
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }
}

class _CongratulationsDialog extends StatelessWidget {
  const _CongratulationsDialog({
    Key? key,
    required this.totalTime,
    required this.numMoves,
  }) : super(key: key);

  final String totalTime;
  final int numMoves;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Text(
          'You have completed the puzzle in $totalTime with $numMoves moves!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        )
      ],
    );
  }
}
