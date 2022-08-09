import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTimerText extends StatelessWidget {
  const GameTimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GameTimer gameTimer = context.watch<GameTimer>();
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();
    if (puzzleBoard.isPuzzleCompleted) gameTimer.endTimer();
    return Text('${gameTimer.hours}:${gameTimer.minutes}:${gameTimer.seconds}');
  }
}
