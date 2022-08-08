import 'package:anime_slide_puzzle/components/game_board/game_board_tile.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoardProvider = context.watch<PuzzleBoard>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.25),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      // adding extra padding for the bottom and right of game board
      width: width + tilePadding,
      height: height + tilePadding,
      child: Consumer<PuzzleBoard>(
        builder: (BuildContext context, PuzzleBoard puzzleBoard, child) {
          return Stack(
            children: [
              for (List<PuzzleTile> puzzleTileRow
                  in puzzleBoardProvider.puzzleBoard2d)
                for (PuzzleTile tile in puzzleTileRow)
                  GameBoardTile(
                    tile: tile,
                    width: width,
                    height: height,
                    tilePadding: tilePadding,
                  )
            ],
          );
        },
      ),
    );
  }
}
