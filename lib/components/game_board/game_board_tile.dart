import 'package:anime_slide_puzzle/components/game_board/Imageless_puzzle_piece.dart';
import 'package:anime_slide_puzzle/components/game_board/background_puzzle_piece.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required this.tile,
    required this.width,
    required this.height,
    required this.tilePadding,
    this.tileBorderRadius = 10,
    this.positionDuration = const Duration(milliseconds: 100),
    this.scaleDuration = const Duration(milliseconds: 100),
    this.textOpacityDuration = const Duration(milliseconds: 100),
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
  bool isLoadingImage = true;
  bool isHovered = false;
  bool imageAssetExist = false;

  void doesImageAssetExist(String path) async {
    try {
      await rootBundle.load(path);
      imageAssetExist = true;
    } catch (error) {
      imageAssetExist = false;
    }
    setState(() {
      isLoadingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    doesImageAssetExist(context.read<PuzzleImageSelector>().curImagePath);
  }

  @override
  Widget build(BuildContext context) {
    final PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
    final PuzzleImageSelector imageSelector =
        context.watch<PuzzleImageSelector>();

    // To calculate the dimensions of the tile, we divide the board width or height
    // we subtract the padding to have padding for right and bottom
    final double tileWidth =
        widget.width / puzzleBoard.numRowsOrColumns - widget.tilePadding;
    final double tileHeight =
        widget.height / puzzleBoard.numRowsOrColumns - widget.tilePadding;

    // To calculate the position of each tile we need to calculate the size of the tile with the padding
    // we also add an additional padding for the top and left
    final double animatedPositionLeft = widget.tilePadding +
        (tileWidth + widget.tilePadding) * widget.tile.currentCoordinate.col;
    final double animatedPositionTop = widget.tilePadding +
        (tileHeight + widget.tilePadding) * widget.tile.currentCoordinate.row;

    return AnimatedPositioned(
      left: animatedPositionLeft,
      top: animatedPositionTop,
      duration: widget.positionDuration,
      child: MouseRegion(
        onEnter: (e) => setState(() => isHovered = true),
        onExit: (e) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: (puzzleBoard.isLookingForSolution)
              ? null
              : () {
                  puzzleBoard.moveTile(
                      clickedTileCoordinate: widget.tile.correctCoordinate);
                },
          child: AnimatedScale(
            duration: widget.scaleDuration,
            scale: isHovered ? .85 : 1,
            child: (!imageAssetExist || isLoadingImage)
                ? ImagelessPuzzle(
                    height: tileHeight,
                    width: tileWidth,
                    tileNumber: widget.tile.tileNumber,
                    isBlankTile: widget.tile.isBlankTile,
                  )
                : BackgroundPuzzlePiece(
                    tile: widget.tile,
                    tileHeight: tileHeight,
                    tileWidth: tileWidth,
                    curImagePath: imageSelector.curImagePath,
                    numRowsOrColumn: puzzleBoard.numRowsOrColumns,
                    tileNumberOpacity: puzzleBoard.currentTileOpacity,
                  ),
          ),
        ),
      ),
    );
  }
}
