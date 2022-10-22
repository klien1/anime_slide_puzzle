import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_board_tile.dart';
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
    List<List<PuzzleTile>> puzzleMatrix =
        context.read<PuzzleBoard>().correctTileMatrix;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      width: width + tilePadding * 2,
      height: height + tilePadding * 2,
      child: Stack(
        children: [
          for (int row = 0; row < puzzleMatrix.length; ++row)
            for (int col = 0; col < puzzleMatrix[row].length; ++col)
              Selector<PuzzleBoard, PuzzleTile>(
                selector: (_, board) => board.correctTileMatrix[row][col],
                builder: (context, tile, child) => (tile.isBlankTile)
                    ? const SizedBox.shrink()
                    : GameBoardTile(
                        tile: tile,
                        width: width,
                        height: height,
                        tilePadding: tilePadding,
                        numRowsOrColumns: puzzleMatrix.length),
              ),
        ],
      ),
    );
  }
}
