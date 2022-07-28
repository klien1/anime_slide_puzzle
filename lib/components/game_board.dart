import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int boardSize = 3;
const double dimension = 100;
const double padding = 10;

class GameBoard extends StatefulWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoard();
}

class _GameBoard extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();

    return Container(
      width: 500,
      height: 500,
      color: Colors.grey,
      child: Container(
        color: Colors.blueGrey,
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (List<PuzzleTile> puzzleTileRow
                in puzzleBoardProvider.puzzleBoard2d)
              for (PuzzleTile tile in puzzleTileRow)
                GameBoardTile(
                  tile: tile,
                  dimension: dimension,
                  padding: padding,
                )
          ],
        ),
      ),
    );
  }
}
