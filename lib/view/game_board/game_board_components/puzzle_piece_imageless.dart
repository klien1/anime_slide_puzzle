import 'package:anime_slide_puzzle/view/game_board/game_board_components/game_board_tile_number.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/material.dart';

class PuzzlePieceImageless extends StatelessWidget {
  const PuzzlePieceImageless({
    Key? key,
    required this.width,
    required this.height,
    required this.tile,
  }) : super(key: key);

  final double width;
  final double height;
  final PuzzleTile tile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: tile.isBlankTile
            ? Colors.lightBlue.withOpacity(0.0)
            : Colors.lightBlue,
      ),
      child: GameBoardTileNumber(
        tile: tile,
        tileHeight: height,
        tileWidth: width,
        alwaysShow: true,
      ),
    );
  }
}
