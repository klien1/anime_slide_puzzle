import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required double gameBoardWidthAndHeight,
    required double padding,
  })  : _gameBoardWidthAndHeight = gameBoardWidthAndHeight,
        _padding = padding,
        super(key: key);

  final double _gameBoardWidthAndHeight;
  final double _padding;

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      // adding extra padding for the bottom and right of game board
      width: _gameBoardWidthAndHeight + _padding,
      height: _gameBoardWidthAndHeight + _padding,
      child: Stack(
        children: [
          for (List<PuzzleTile> puzzleTileRow
              in puzzleBoardProvider.puzzleBoard2d)
            for (PuzzleTile tile in puzzleTileRow)
              GameBoardTile(
                tile: tile,
                gameBoardWidthAndHeight: _gameBoardWidthAndHeight,
                padding: _padding,
              )
        ],
      ),
    );
  }
}
