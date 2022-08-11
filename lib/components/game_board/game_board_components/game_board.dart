import 'package:anime_slide_puzzle/components/game_board/game_board_components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/game_timer.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/screens/congratulations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    required this.width,
    required this.height,
    required this.tilePadding,
  }) : super(key: key);

  final double width;
  final double height;
  final double tilePadding;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  GameTimer? gameTimer;
  PuzzleBoard? puzzleBoard;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    gameTimer = context.read<GameTimer>();
    puzzleBoard = context.read<PuzzleBoard>();
  }

  @override
  void dispose() {
    gameTimer
      ?..resetTimer()
      ..endTimer();
    puzzleBoard
      ?..resetNumberOfMoves()
      ..resetBoard();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<List<PuzzleTile>> puzzleMatrix =
        context.read<PuzzleBoard>().puzzleBoard2d;

    return Selector<PuzzleBoard, bool>(
      selector: (_, puzzleBoard) => puzzleBoard.isPuzzleCompleted,
      builder: (_, puzzleCompleted, child) {
        if (puzzleCompleted) {
          Future.delayed(
            Duration.zero,
            () => showDialog(
              context: context,
              builder: (context) => const Congratulations(),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black)),
          width: widget.width + widget.tilePadding * 2,
          height: widget.height + widget.tilePadding * 2,
          child: Stack(children: [
            for (int row = 0; row < puzzleMatrix.length; ++row)
              for (int col = 0; col < puzzleMatrix[row].length; ++col)
                Selector<PuzzleBoard, PuzzleTile>(
                  selector: (_, board) => board.puzzleBoard2d[row][col],
                  builder: (context, tile, child) {
                    return GameBoardTile(
                      tile: tile,
                      width: widget.width,
                      height: widget.height,
                      tilePadding: widget.tilePadding,
                    );
                  },
                )
          ]),
        );
      },
    );
  }
}