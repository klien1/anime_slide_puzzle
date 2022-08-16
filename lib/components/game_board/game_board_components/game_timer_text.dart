import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTimerText extends StatefulWidget {
  const GameTimerText({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  State<GameTimerText> createState() => _GameTimerTextState();
}

class _GameTimerTextState extends State<GameTimerText> {
  GameTimer? gameTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameTimer = context.watch<GameTimer>();
  }

  @override
  void dispose() {
    gameTimer
      ?..endTimer()
      ..resetTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PuzzleBoard puzzleBoard = context.watch<PuzzleBoard>();
    if (puzzleBoard.isPuzzleCompleted) gameTimer?.endTimer();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: Icon(Icons.alarm_rounded, size: widget.size),
        ),
        const SizedBox(width: 5),
        Text(gameTimer?.totalTime ?? '',
            style: TextStyle(fontSize: widget.size)),
      ],
    );
  }
}
