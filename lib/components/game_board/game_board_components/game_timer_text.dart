import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class GameTimerText extends StatelessWidget {
  const GameTimerText({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.alarm_rounded, size: size),
        const SizedBox(width: 5),
        _TimerText(size: size)
      ],
    );
  }
}

class _TimerText extends StatefulWidget {
  const _TimerText({Key? key, this.size}) : super(key: key);

  final double? size;

  @override
  State<_TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<_TimerText> {
  GameTimer? gameTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gameTimer = Provider.of<GameTimer>(context, listen: true);
  }

  @override
  Widget build(BuildContext context) {
    bool isPuzzleCompleted = context.select<PuzzleBoard, bool>(
        (puzzleBoard) => puzzleBoard.isPuzzleCompleted);

    if (isPuzzleCompleted) gameTimer?.endTimer();

    return Text(
      gameTimer?.elapsedTime ?? '00:00',
      style: TextStyle(fontSize: widget.size),
    );
  }
}
