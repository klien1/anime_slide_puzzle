import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_timer_text.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatus extends StatelessWidget {
  const GameStatus({
    Key? key,
    this.spaceBetween = 10,
    this.size,
  }) : super(key: key);

  final double spaceBetween;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxHeight < 60) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
                flex: 2,
                child: Text(
                  'Number of Moves: ${context.watch<PuzzleBoard>().numberOfMoves}',
                  style: TextStyle(fontSize: size),
                )),
            Flexible(child: GameTimerText(size: size)),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: GameTimerText(size: size)),
            SizedBox(height: spaceBetween),
            Flexible(
                child: Text(
              'Number of Moves: ${context.watch<PuzzleBoard>().numberOfMoves}',
              style: TextStyle(fontSize: size),
              textAlign: TextAlign.center,
            )),
          ],
        );
      }
    });
  }
}
