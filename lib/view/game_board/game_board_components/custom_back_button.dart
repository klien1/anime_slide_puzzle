import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        context.read<GameTimer>().endTimer();
        context.read<PuzzleBoard>().resetBoard();
        Navigator.pop(context);
      },
    );
  }
}
