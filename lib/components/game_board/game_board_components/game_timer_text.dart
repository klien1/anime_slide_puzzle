import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTimerText extends StatelessWidget {
  const GameTimerText({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    GameTimer gameTimer = context.watch<GameTimer>();
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();
    if (puzzleBoard.isPuzzleCompleted) gameTimer.endTimer();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.alarm_rounded,
            size: size,
          ),
        ),
        const SizedBox(width: 5),
        Text(gameTimer.totalTime, style: TextStyle(fontSize: size)),
      ],
    );
  }
}
