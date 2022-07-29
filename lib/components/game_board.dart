import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required int boardSize,
    // required double tileDimension,
    required double boardDimension,
    required double padding,
  })  : _boardSize = boardSize,
        // _tileDimension = tileDimension,
        _boardDimension = boardDimension,
        _padding = padding,
        super(key: key);

  final int _boardSize;
  // final double _tileDimension;
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
      // color: Colors.grey,
      child: Stack(
        alignment: Alignment.center,
        // clipBehavior: Clip.none,
        children: [
          // GameBoardTile(
          //     tile: puzzleBoardProvider.puzzleBoard2d[0][0],
          //     boardDimension: _boardDimension,
          //     padding: _padding),
          // GameBoardTile(
          //     tile: puzzleBoardProvider.puzzleBoard2d[0][1],
          //     boardDimension: _boardDimension,
          //     padding: _padding),
          // GameBoardTile(
          //     tile: puzzleBoardProvider.puzzleBoard2d[0][2],
          //     boardDimension: _boardDimension,
          //     padding: _padding)
          for (List<PuzzleTile> puzzleTileRow
              in puzzleBoardProvider.puzzleBoard2d)
            for (PuzzleTile tile in puzzleTileRow)
              GameBoardTile(
                tile: tile,
                // tileDimension: _tileDimension,
                boardDimension: _boardDimension,
                padding: _padding,
              )
        ],
      ),
    );
  }
}
