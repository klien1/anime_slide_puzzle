import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required PuzzleTile tile,
    required double boardDimension,
    required double padding,
  })  : _boardDimension = boardDimension,
        _padding = padding,
        _tile = tile,
        super(key: key);

  final PuzzleTile _tile;
  final double _boardDimension;
  final double _padding;

  @override
  State<GameBoardTile> createState() => _GameBoardTile();
}

class _GameBoardTile extends State<GameBoardTile> {
  bool isHovered = false;
  bool imageAssetExist = false;

  void doesImageAssetExist(String path) async {
    try {
      await rootBundle.load(path);
      imageAssetExist = true;
    } catch (error) {
      imageAssetExist = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    doesImageAssetExist(context.read<PuzzleImageChanger>().curImagePath);
  }

  @override
  Widget build(BuildContext context) {
    // To calculate the dimensions of the tile, we divide the
    final double tileDimension = (widget._boardDimension) /
            context.read<PuzzleBoard>().numRowsOrColumns -
        widget._padding;

    // To calculate the position of each tile we need to calculate the size of the tile with the padding
    //
    final double animatedPositionLeft = widget._padding +
        (tileDimension + widget._padding) * widget._tile.currentCoordinate.y;
    final double animatedPositionTop = widget._padding +
        (tileDimension + widget._padding) * widget._tile.currentCoordinate.x;

    return AnimatedPositioned(
      left: animatedPositionLeft,
      top: animatedPositionTop,
      duration: const Duration(milliseconds: 200),
      child: MouseRegion(
        onEnter: (e) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (e) {
          setState(() {
            isHovered = false;
          });
        },
        child: GestureDetector(
          onTap: () {
            final PuzzleBoard puzzleBoard = context.read<PuzzleBoard>();
            puzzleBoard.move(
              clickedTileCoordinate: widget._tile.correctCoordinate,
            );
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isHovered ? .85 : 1,
            child: (!imageAssetExist)
                ? imagelessPuzzle(context, tileDimension)
                : backgroundPuzzle(context, widget._tile.correctCoordinate.y,
                    widget._tile.correctCoordinate.x, tileDimension),
          ),
        ),
      ),
    );
  }

  Widget backgroundPuzzle(
      BuildContext context, int curRow, int curCol, double tileDimension) {
    final numTilesPerRowOrColumn = context.read<PuzzleBoard>().numRowsOrColumns;
    PuzzleImageChanger puzzleImageChanger = context.watch<PuzzleImageChanger>();

    // check if numTilesPerRowOrColumn == 1 to avoid divide by zero error
    // we will return the full image if there is only 1 tile
    if (numTilesPerRowOrColumn == 1) {
      return SizedBox(
        height: tileDimension,
        width: tileDimension,
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(puzzleImageChanger.curImagePath),
        ),
      );
    }

    // Offset position starts at center of image Offset(0, 0)
    // To get topLeft position we need to move half of the container's size left and up
    // Offset (-halfOfTileSize, halfOfTileSize)
    final double topLeftPosition = -tileDimension / 2;

    //
    final sizeOfTile = tileDimension / (numTilesPerRowOrColumn - 1);

    final offset = Offset(
      topLeftPosition + sizeOfTile * curRow,
      topLeftPosition + sizeOfTile * curCol,
    );

    return SizedBox(
      height: tileDimension,
      width: tileDimension,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: OverflowBox(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          child: Transform.scale(
            scale: (numTilesPerRowOrColumn).toDouble(),
            origin: offset,
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
    );
  }

  Container imagelessPuzzle(BuildContext context, tileDimension) {
    return Container(
      width: tileDimension,
      height: tileDimension,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: widget._tile.isBlankTile
            ? Colors.lightBlue.withOpacity(0.0)
            : Colors.lightBlue,
      ),
      child: Center(
        child: Text(
          (widget._tile.correctCoordinate.x *
                      context.read<PuzzleBoard>().numRowsOrColumns +
                  widget._tile.correctCoordinate.y)
              .toString(),
          style: TextStyle(
            color: widget._tile.isBlankTile
                ? Colors.black.withOpacity(0.0)
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

// 1 8 2 x 4 3 7 6 5
//   7     1   2

// 1 0 3 2
// 1   1
// N is even

/*

1 0
2 3


1 0 2 3
1

N = 2 = EVEN
Inversion = 1

*/