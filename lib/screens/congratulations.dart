import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Congratulations extends StatelessWidget {
  const Congratulations({Key? key}) : super(key: key);

  static String id = 'congratulations_screen';

  @override
  Widget build(BuildContext context) {
    int numMoves = context.read<PuzzleBoard>().numberOfMoves;
    GameTimer gameTimer = context.read<GameTimer>();

    return AlertDialog(
      title: const Text('Congratulations!'),
      content: Text(
          'You have completed the puzzle in ${gameTimer.totalTime} with $numMoves moves!'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        )
      ],
    );
  }
}
