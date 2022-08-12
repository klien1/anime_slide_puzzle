import 'package:anime_slide_puzzle/components/game_board/game_board_components/no_image_puzzle_piece.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/background_puzzle_piece.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/constants.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required this.tile,
    required this.width,
    required this.height,
    required this.tilePadding,
    this.tileBorderRadius = 10,
    this.positionDuration = defaultTileSpeed,
    this.scaleDuration = defaultTileSpeed,
    this.textOpacityDuration = defaultTileSpeed,
  }) : super(key: key);

  final PuzzleTile tile;
  final double width;
  final double height;
  final double tilePadding;
  final double tileBorderRadius;
  final Duration positionDuration;
  final Duration scaleDuration;
  final Duration textOpacityDuration;

  @override
  State<GameBoardTile> createState() => _GameBoardTile();
}

class _GameBoardTile extends State<GameBoardTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();

    // To calculate the dimensions of the tile, we divide the board width or height
    // we subtract the padding to have padding for right and bottom
    final double tileWidth =
        widget.width / puzzleBoard.numRowsOrColumns - widget.tilePadding;
    final double tileHeight =
        widget.height / puzzleBoard.numRowsOrColumns - widget.tilePadding;

    // To calculate the position of each tile we need to calculate the size of the tile with the padding
    // we also add an additional padding for the top and left
    final Coordinate curTileCoordiante = widget.tile.currentCoordinate;

    final double animatedPositionLeft = widget.tilePadding +
        (tileWidth + widget.tilePadding) * curTileCoordiante.col;

    final double animatedPositionTop = widget.tilePadding +
        (tileHeight + widget.tilePadding) * curTileCoordiante.row;

    return AnimatedPositioned(
      left: animatedPositionLeft,
      top: animatedPositionTop,
      duration: widget.positionDuration,
      child: GestureDetector(
        onTap: (puzzleBoard.isLookingForSolution)
            ? null
            : () {
                puzzleBoard.moveTile(
                  correctTileCoordinate: widget.tile.correctCoordinate,
                );
              },
        child: MouseRegion(
          onEnter: (event) => setState(() => isHovered = true),
          onExit: (event) => setState(() => isHovered = false),
          child: AnimatedScale(
            duration: widget.scaleDuration,
            scale: isHovered ? .90 : 1,
            child: Opacity(
              opacity: (widget.tile.isBlankTile) ? 0 : 1,
              child: Material(
                elevation: 10,
                color: Colors.white.withOpacity(0),
                child: (animeThemeList.isLoadingImage)
                    ? NoImagePuzzlePiece(
                        height: tileHeight,
                        width: tileWidth,
                        tile: widget.tile,
                      )
                    : BackgroundPuzzlePiece(
                        tile: widget.tile,
                        tileHeight: tileHeight,
                        tileWidth: tileWidth,
                        curImagePath: animeThemeList.curPuzzle,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
