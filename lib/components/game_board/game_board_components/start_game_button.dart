import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class StartGameButton extends StatefulWidget {
  const StartGameButton({Key? key}) : super(key: key);

  @override
  State<StartGameButton> createState() => _StartGameButtonState();
}

class _StartGameButtonState extends State<StartGameButton> {
  Future<void> shuffleBoard() async {
    PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
    await puzzleBoard.startGame(3);

    if (!mounted) return;
    context.read<GameTimer>().startStream();
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
      onPressed: (isLookingForSolution || isShuffling) ? null : shuffleBoard,
      child: (isGameInProgress)
          ? const Text('Restart Game')
          : const Text('Start Game'),
    );
  }
}
