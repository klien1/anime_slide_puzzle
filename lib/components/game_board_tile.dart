import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:anime_slide_puzzle/utils/puzzle_tile_clipper.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_changer.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required PuzzleTile tile,
    // required double tileDimension,
    required double boardDimension,
    required double padding,
  })  :
        // _tileDimension = tileDimension,
        _boardDimension = boardDimension,
        _padding = padding,
        _tile = tile,
        super(key: key);

  final PuzzleTile _tile;
  // final double _tileDimension;
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
  }

  @override
  void initState() {
    super.initState();
    doesImageAssetExist(context.read<PuzzleImageChanger>().curImagePath);
  }

  @override
  Widget build(BuildContext context) {
    // final AssetImage? _assetImage = context.read<AssetImage?>();
    // final AssetImage? _assetImage = null;

    final double tileDimension =
        (widget._boardDimension) / context.read<PuzzleBoard>().size -
            widget._padding;
    // widget._padding * context.read<PuzzleBoard>().size;

    return
        // AnimatedPositioned(
        //   left: widget._padding +
        //       (tileDimension + widget._padding) * widget._tile.currentCoordinate.y,
        //   top: widget._padding +
        //       (tileDimension + widget._padding) * widget._tile.currentCoordinate.x,
        //   duration: const Duration(milliseconds: 200),
        //   child: backgroundPuzzle(context, widget._tile.correctCoordinate.y,
        //       widget._tile.correctCoordinate.x, tileDimension),
        // );
        // AnimatedPositioned(
        //   duration: Duration(milliseconds: 200),
        //   child: AnimatedScale(
        //     duration: const Duration(milliseconds: 200),
        //     scale: isHovered ? .85 : 1,
        //     child: backgroundPuzzle(context, widget._tile.correctCoordinate.y,
        //         widget._tile.correctCoordinate.x, tileDimension),
        //   ),
        // );

        AnimatedPositioned(
      left: widget._padding +
          (tileDimension + widget._padding) * widget._tile.currentCoordinate.y,
      top: widget._padding +
          (tileDimension + widget._padding) * widget._tile.currentCoordinate.x,
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
    final numTiles = context.read<PuzzleBoard>().size;
    print(
      '$numTiles, $curRow, $curCol, $tileDimension, ${tileDimension / numTiles}',
    );

    PuzzleImageChanger puzzleImageChanger = context.watch<PuzzleImageChanger>();

    return SizedBox(
      height: tileDimension,
      width: tileDimension,
      child: ClipRect(
        child: OverflowBox(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          child: Transform.scale(
            scale: numTiles.toDouble(),
            // origin: Offset(curRow.toDouble(), curCol.toDouble()
            origin: Offset(
                // -tileDimension / numTiles, -tileDimension / numTiles + 8),
                // -tileDimension / numTiles, -tileDimension / numTiles + 8),
                -tileDimension / numTiles,
                -44),
            //double imageTop = -0.5 + (1 * defaultRow / (widget.gridSize -1));
            //double imageLeft = -0.5 + (1 * defaultColumn / (widget.gridSize - 1));
            // -0.5 + (1 * curCol / (numTiles)),
            // -0.5 + (1 * curRow / (numTiles)),
            // (-1 + 0.5 * curRow) * tileDimension,
            // (-1 + 0.5 * curCol) * tileDimension,
            // ),
            child: SizedBox(
              height: double.minPositive,
              width: double.minPositive,
              child: Image(
                // fit: BoxFit.cover,
                image: AssetImage(puzzleImageChanger.curImagePath),
              ),
            ),
          ),
        ),
      ),
    );

    // ClipPath(
    //   clipper: PuzzleTileClipper(
    //     curCol: curRow,
    //     curRow: curCol,
    //     tileDimension: tileDimension,
    //   ),
    //   child: SizedBox(
    //     height: widget._boardDimension,
    //     width: widget._boardDimension,
    //     // clipBehavior: Clip.none,
    //     // clipper: PuzzleTileClipper(
    //     //   curCol: curRow,
    //     //   curRow: curCol,
    //     //   tileDimension: tileDimension,
    //     // ),
    //     child: Image(
    //       fit: BoxFit.cover,
    //       image: context.read<AssetImage>(),
    //     ),
    //   ),
    // );

    //     SizedBox(
    //   height: tileDimension,
    //   width: tileDimension,
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(20),
    //     child: OverflowBox(
    //       // alignment: Alignment(-1, 1),
    //       alignment: Alignment(-1 + 0.5 * curRow, -1 + 0.5 * curCol),
    //       // alignment: Alignment(
    //       // -1 + (2 / numTiles) * alignX, -1 + (2 / numTiles) * alignY),
    //       maxWidth: double.infinity,
    //       maxHeight: double.infinity,
    //       child: Opacity(
    //         opacity: widget._tile.isBlankTile ? 0 : 1,
    //         child: Image(
    //           fit: BoxFit.cover,
    //           image: context.read<AssetImage>(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
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
          (widget._tile.correctCoordinate.x * context.read<PuzzleBoard>().size +
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


/*

defaultIndex == correct index
grid size is number in row / col

int defaultRow = (thisTile.defaultIndex / widget.gridSize).floor();

int defaultColumn = thisTile.defaultIndex % widget.gridSize;


double imageTop = -0.5 + (1 * defaultRow / (widget.gridSize -1));

double imageLeft = -0.5 + (1 * defaultColumn / (widget.gridSize - 1));

height = size of tile

Offset finalImageOffset = Offset(height * imageLeft, height * imageTop);


*/