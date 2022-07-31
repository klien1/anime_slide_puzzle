import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/models/tile_number_opacity.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required PuzzleTile tile,
    required double gameBoardWidthAndHeight,
    required double tilePadding,
  })  : _gameBoardWidthAndHeight = gameBoardWidthAndHeight,
        _tilePadding = tilePadding,
        _tile = tile,
        super(key: key);

  final PuzzleTile _tile;
  final double _gameBoardWidthAndHeight;
  final double _tilePadding;

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

    // To calculate the dimensions of the tile, we divide the board width or height
    // we subtract the padding to have padding for right and bottom
    final double tileWidthOrHeight =
        widget._gameBoardWidthAndHeight / puzzleBoard.numRowsOrColumns -
            widget._tilePadding;

    // To calculate the position of each tile we need to calculate the size of the tile with the padding
    // we also add an additional padding for the top and left
    final double animatedPositionLeft = widget._tilePadding +
        (tileWidthOrHeight + widget._tilePadding) *
            widget._tile.currentCoordinate.y;
    final double animatedPositionTop = widget._tilePadding +
        (tileWidthOrHeight + widget._tilePadding) *
            widget._tile.currentCoordinate.x;

    return AnimatedPositioned(
      left: animatedPositionLeft,
      top: animatedPositionTop,
      duration: const Duration(milliseconds: 100),
      child: MouseRegion(
        onEnter: (e) => setState(() => isHovered = true),
        onExit: (e) => setState(() => isHovered = false),
        child: GestureDetector(
          onTap: () {
            puzzleBoard.moveTile(
              clickedTileCoordinate: widget._tile.correctCoordinate,
            );
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 100),
            scale: isHovered ? .85 : 1,
            child: (!imageAssetExist || isLoadingImage)
                ? imagelessPuzzle(context, tileWidthOrHeight)
                : backgroundPuzzle(context, widget._tile.correctCoordinate.y,
                    widget._tile.correctCoordinate.x, tileWidthOrHeight),
          ),
        ),
      ),
    );
  }

  Widget backgroundPuzzle(
      BuildContext context, int curRow, int curCol, double tileWidthOrHeight) {
    final numTilesPerRowOrColumn = context.read<PuzzleBoard>().numRowsOrColumns;
    PuzzleImageSelector puzzleImageChanger =
        context.watch<PuzzleImageSelector>();

    TileNumberOpacity tileNumberOpacity = context.watch<TileNumberOpacity>();

    // check if numTilesPerRowOrColumn == 1 to avoid divide by zero error
    // we will return the full image if there is only 1 tile
    if (numTilesPerRowOrColumn == 1) {
      return SizedBox(
        height: tileWidthOrHeight,
        width: tileWidthOrHeight,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(puzzleImageChanger.curImagePath),
        ),
      );
    }

    // Offset position starts at center of image Offset(0, 0)
    // To get topLeft position we need to move half of the container's size up and left
    final double topLeftPosition = -tileWidthOrHeight / 2;

    // we divide tileWidthOrHeight by (numTilesPerRowOrColumn - 1) to calcutate
    // offset for the remaining points since we already have the starting point
    final offset = tileWidthOrHeight / (numTilesPerRowOrColumn - 1);

    final originOffset = Offset(
      topLeftPosition + offset * curRow,
      topLeftPosition + offset * curCol,
    );

    return Stack(
      children: [
        SizedBox(
          height: tileWidthOrHeight,
          width: tileWidthOrHeight,
          child: ClipRect(
            child: OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: Transform.scale(
                scale: numTilesPerRowOrColumn.toDouble(),
                origin: originOffset,
                child: SizedBox(
                  height: double.minPositive,
                  width: double.minPositive,
                  child: Opacity(
                    opacity: widget._tile.isBlankTile ? 0 : 1,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(puzzleImageChanger.curImagePath),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: tileWidthOrHeight / 3,
          top: offset,
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: (widget._tile.isBlankTile)
                ? 0
                : tileNumberOpacity.currentOpacity,
            child: OutlinedText(
              widget._tile.tileNumber.toString(),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              strokeColor: Colors.black,
              strokeWidth: 2,
              textColor: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Container imagelessPuzzle(BuildContext context, double tileWidthOrHeight) {
    return Container(
      width: tileWidthOrHeight,
      height: tileWidthOrHeight,
      decoration: BoxDecoration(
        color: widget._tile.isBlankTile
            ? Colors.lightBlue.withOpacity(0.0)
            : Colors.lightBlue,
      ),
      child: Center(
        child: Text(
          widget._tile.tileNumber.toString(),
          style: TextStyle(
            color: widget._tile.isBlankTile
                ? Colors.black.withOpacity(0.0)
                : Colors.black,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

class OutlinedText extends StatelessWidget {
  /// Text to display
  final String text;

  /// Original text style (if you weren't outlining)
  ///
  /// Do not specify `color` inside this: use [textColor] instead.
  final TextStyle style;

  /// Text color
  final Color textColor;

  /// Outline stroke color
  final Color strokeColor;

  /// Outline stroke width
  final double strokeWidth;

  /// Places a stroke around text to make it appear outlined
  ///
  /// Adapted from https://stackoverflow.com/a/55559435/11846040
  const OutlinedText(
    this.text, {
    Key? key,
    this.style = const TextStyle(),
    required this.textColor,
    required this.strokeColor,
    required this.strokeWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: style.copyWith(foreground: Paint()..color = textColor),
        ),
        Text(
          text,
          style: style.copyWith(
            foreground: Paint()
              ..strokeWidth = strokeWidth
              ..color = strokeColor
              ..style = PaintingStyle.stroke,
          ),
        ),
      ],
    );
  }
}
