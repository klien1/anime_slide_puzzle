import 'package:anime_slide_puzzle/components/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    Key? key,
    required double gameBoardWidthAndHeight,
    required double tilePadding,
  })  : _gameBoardWidthAndHeight = gameBoardWidthAndHeight,
        _tilePadding = tilePadding,
        super(key: key);

  final double _gameBoardWidthAndHeight;
  final double _tilePadding;

  @override
  Widget build(BuildContext context) {
    print('rebuilding board');
    final PuzzleBoard puzzleBoardProvider = context.read<PuzzleBoard>();
    // final int numRowOrCol = context.watch<PuzzleBoard>().numRowsOrColumns;
    // print('game board rebuilding');
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(
          color: Colors.black,
        ),
      ),
      // adding extra padding for the bottom and right of game board
      width: _gameBoardWidthAndHeight + _tilePadding,
      height: _gameBoardWidthAndHeight + _tilePadding,
      child: Stack(
        children: [
          for (List<PuzzleTile> puzzleTileRow
              in puzzleBoardProvider.puzzleBoard2d)
            for (PuzzleTile tile in puzzleTileRow)
              GameBoardTile(
                tile: tile,
                gameBoardWidthAndHeight: _gameBoardWidthAndHeight,
                tilePadding: _tilePadding,
              )
        ],
      ),
    );
  }
}
