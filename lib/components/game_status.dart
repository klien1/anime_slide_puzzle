import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Number of Moves: ${context.watch<PuzzleBoard>().numberOfMoves}'),
        Text(
          'Solving puzzle...',
          style: TextStyle(
            color: Colors.black.withOpacity(
                (context.watch<PuzzleBoard>().isLookingForSolution) ? 1 : 0),
          ),
        )
      ],
    );
  }
}
