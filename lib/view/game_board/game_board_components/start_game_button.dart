import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class StartGameButton extends StatelessWidget {
  const StartGameButton({Key? key}) : super(key: key);

  void _startGame(BuildContext context) {
    context.read<GameTimer>().endTimer();
    context.read<PuzzleBoard>().startGame(3);
  }

  @override
  Widget build(BuildContext context) {
    Tuple3<bool, bool, bool> boardStatus =
        context.select<PuzzleBoard, Tuple3<bool, bool, bool>>(
      (puzzleBoard) => Tuple3(
        puzzleBoard.isLookingForSolution,
        puzzleBoard.isShuffling,
        puzzleBoard.isGameInProgress,
      ),
    );

    final bool isLookingForSolution = boardStatus.item1;
    final bool isShuffling = boardStatus.item2;
    final bool isGameInProgress = boardStatus.item3;

    return TextButton(
      onPressed: (isLookingForSolution || isShuffling)
          ? null
          : () => _startGame(context),
      child: (isGameInProgress)
          ? const Text('Restart Game')
          : const Text('Start Game'),
    );
  }
}
