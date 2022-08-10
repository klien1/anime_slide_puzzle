import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_timer_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const GameTimerText(),
        const SizedBox(height: 10),
        Text('Number of Moves: ${context.watch<PuzzleBoard>().numberOfMoves}'),
        const SizedBox(height: 10),
        Opacity(
          opacity: (context.watch<PuzzleBoard>().isLookingForSolution) ? 1 : 0,
          child: const Text('Solving puzzle...'),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
