import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_timer_text.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({Key? key, this.spaceBetween = 10}) : super(key: key);

  final double spaceBetween;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const GameTimerText(),
        SizedBox(height: spaceBetween),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Number of Moves:'),
            Text('${context.watch<PuzzleBoard>().numberOfMoves}')
          ],
        )
        // Text('Number of Moves: ${context.watch<PuzzleBoard>().numberOfMoves}'),
      ],
    );
  }
}
