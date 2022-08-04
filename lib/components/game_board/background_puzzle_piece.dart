import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/components/game_board/bordered_text.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';

class BackgroundPuzzlePiece extends StatelessWidget {
  const BackgroundPuzzlePiece({
    Key? key,
    required this.tile,
    required this.tileHeight,
    required this.tileWidth,
    required this.curImagePath,
    required this.numRowsOrColumn,
    this.tileNumberOpacity = 1,
    this.tileBorderRadius = 10,
    this.textOpacityDuration = const Duration(milliseconds: 200),
  }) : super(key: key);

  final PuzzleTile tile;
  final double tileHeight;
  final double tileWidth;
  final double tileBorderRadius;
  final double tileNumberOpacity;
  final int numRowsOrColumn;
  final Duration textOpacityDuration;
  final String curImagePath;

  Widget fullImage() {
    return SizedBox(
      height: tileHeight,
      width: tileWidth,
      child: Image(
        fit: BoxFit.cover,
        image: AssetImage(curImagePath),
      ),
    );
  }

  Widget dividedImage() {
    final int curRow = tile.correctCoordinate.row;
    final int curCol = tile.correctCoordinate.col;

    // Offset position starts at center of image Offset(0, 0)
    // To get topLeft position we need to move half of the container's size up and left
    final double topPosition = -tileHeight / 2;
    final double leftPosition = -tileWidth / 2;

    // we divide tileWidthOrHeight by (numTilesPerRowOrColumn - 1) to calcutate
    // offset for the remaining points since we already have the starting point
    final topOffset = tileHeight / (numRowsOrColumn - 1);
    final leftOffset = tileWidth / (numRowsOrColumn - 1);

    final originOffset = Offset(
      leftPosition + leftOffset * curCol,
      topPosition + topOffset * curRow,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: tileHeight,
          width: tileWidth,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(tileBorderRadius),
            child: OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: Transform.scale(
                scale: numRowsOrColumn.toDouble(),
                origin: originOffset,
                child: SizedBox(
                  height: double.minPositive,
                  width: double.minPositive,
                  child: Opacity(
                    opacity: tile.isBlankTile ? 0 : 1,
                    child: Image(
                      fit: BoxFit.cover,
                      image: AssetImage(curImagePath),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: tileHeight / 2,
          width: tileWidth / 2,
          child: FittedBox(
            fit: BoxFit.contain,
            child: AnimatedOpacity(
              duration: textOpacityDuration, //const Duration(seconds: 1),
              opacity: (tile.isBlankTile) ? 0 : tileNumberOpacity,
              child: BorderedText(
                text: (tile.tileNumber + 1).toString(),
                style: const TextStyle(fontFamily: 'Bangers'),
                textColor: Colors.black,
                strokeColor: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // check if numTilesPerRowOrColumn == 1 to avoid divide by zero error
    // we will return the full image if there is only 1 tile
    return (numRowsOrColumn == 1) ? fullImage() : dividedImage();
  }
}