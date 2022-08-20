import 'package:anime_slide_puzzle/components/game_board/game_board_components/puzzle_piece_imageless.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/puzzle_piece_background_image.dart';
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
  }) : super(key: key);

  final PuzzleTile tile;
  final double width;
  final double height;
  final double tilePadding;
  final double tileBorderRadius;
  final Duration positionDuration;
  final Duration scaleDuration;

  @override
  State<GameBoardTile> createState() => _GameBoardTile();
}

class _GameBoardTile extends State<GameBoardTile> {
  bool isHovered = false;
  late double animatedPositionLeft;
  late double animatedPositionTop;
  late double tileWidth;
  late double tileHeight;

  void _calculationTileDimensions(puzzleBoard) {
    // To calculate the dimensions of the tile, we divide the board width or height
    // we subtract the padding to have padding for right and bottom
    tileWidth =
        widget.width / puzzleBoard.numRowsOrColumns - widget.tilePadding;
    tileHeight =
        widget.height / puzzleBoard.numRowsOrColumns - widget.tilePadding;

    // To calculate the position of each tile we need to calculate the size of the tile with the padding
    // we also add an additional padding for the top and left
    final Coordinate curTileCoordiante = widget.tile.currentCoordinate;

    animatedPositionLeft = widget.tilePadding +
        (tileWidth + widget.tilePadding) * curTileCoordiante.col;

    animatedPositionTop = widget.tilePadding +
        (tileHeight + widget.tilePadding) * curTileCoordiante.row;
  }

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
    final AnimeThemeList animeThemeList = context.read<AnimeThemeList>();

    _calculationTileDimensions(puzzleBoard);

    return AnimatedPositioned(
      left: animatedPositionLeft,
      top: animatedPositionTop,
      duration: (puzzleBoard.isShuffling)
          ? const Duration(milliseconds: 800)
          : widget.positionDuration,
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: (puzzleBoard.isLookingForSolution)
              ? null
              : () => puzzleBoard.moveTile(
                    correctTileCoordinate: widget.tile.correctCoordinate,
                  ),
          child: MouseRegion(
            onEnter: (event) => setState(() => isHovered = true),
            onExit: (event) => setState(() => isHovered = false),
            child: AnimatedScale(
              duration: widget.scaleDuration,
              scale: isHovered ? .90 : 1,
              child: Material(
                elevation: 5,
                color: Colors.white.withOpacity(0),
                child: (animeThemeList.isLoadingImage)
                    ? PuzzlePieceImageless(
                        height: tileHeight,
                        width: tileWidth,
                        tile: widget.tile,
                      )
                    : PuzzlePieceBackground(
                        tile: widget.tile,
                        tileHeight: tileHeight,
                        tileWidth: tileWidth,
                        curImagePath: animeThemeList.curPuzzle,
                        numRowsOrColumn: puzzleBoard.numRowsOrColumns,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
