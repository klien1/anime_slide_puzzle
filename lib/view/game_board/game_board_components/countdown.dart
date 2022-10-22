import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Countdown extends StatelessWidget {
  const Countdown({Key? key, required this.textSize}) : super(key: key);

  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Selector<PuzzleBoard, Tuple2<bool, int>>(
      selector: (_, puzzleBoard) =>
          Tuple2(puzzleBoard.isShuffling, puzzleBoard.curCountdown),
      builder: (context, value, child) {
        bool isShuffling = value.item1;
        int curCountdown = value.item2;

        return (!isShuffling)
            ? const SizedBox.shrink()
            : AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  (curCountdown == 0) ? 'GO!' : curCountdown.toString(),
                  style: TextStyle(fontSize: textSize),
                ),
              );
      },
    );
  }
}
