import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required double boardDimension,
    required double padding,
  })  : _boardDimension = boardDimension,
        _padding = padding,
        super(key: key);

  final double _boardDimension;
  final double _padding;

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();
    // final double boardDimension = _boardSize * (_tileDimension + _padding);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      width: _boardDimension + _padding,
      height: _boardDimension + _padding,
      child: Stack(
        // alignment: Alignment.center,
        children: [
          for (List<PuzzleTile> puzzleTileRow
              in puzzleBoardProvider.puzzleBoard2d)
            for (PuzzleTile tile in puzzleTileRow)
              GameBoardTile(
                tile: tile,
                boardDimension: _boardDimension,
                padding: _padding,
              )
        ],
      ),
    );
  }
}
