import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({
    Key? key,
    int boardSize = 3,
    double dimension = 100,
    double padding = 20,
  })  : _boardSize = boardSize,
        _dimension = dimension,
        _padding = padding,
        super(key: key);

  final int _boardSize;
  final double _dimension;
  final double _padding;

  @override
  State<GameBoard> createState() => _GameBoard();
}

class _GameBoard extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();

    return Container(
      width: widget._boardSize * (widget._dimension + widget._padding),
      height: widget._boardSize * (widget._dimension + widget._padding),
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
                  dimension: widget._dimension,
                  padding: widget._padding,
                )
          ],
        ),
      ),
    );
  }
}
