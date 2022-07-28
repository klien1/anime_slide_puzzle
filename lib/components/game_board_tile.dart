import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:flutter/material.dart';

class GameBoardTile extends StatefulWidget {
  const GameBoardTile({
    Key? key,
    required PuzzleTile tile,
    required double dimension,
    required double padding,
  })  : _dimension = dimension,
        _padding = padding,
        _tile = tile,
        super(key: key);

  final PuzzleTile _tile;
  final double _dimension;
  final double _padding;

  @override
  State<GameBoardTile> createState() => _GameBoardTile();
}

class _GameBoardTile extends State<GameBoardTile> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: widget._padding / 2 +
          (widget._dimension + widget._padding) *
              widget._tile.currentCoordinate.y,
      top: widget._padding / 2 +
          (widget._dimension + widget._padding) *
              widget._tile.currentCoordinate.x,
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
              correctTilePosition: widget._tile.correctCoordinate,
            );
          },
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: isHovered ? .85 : 1,
            child: Container(
              width: widget._dimension,
              height: widget._dimension,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget._tile.isBlankTile
                    ? Colors.lightBlue.withOpacity(0.0)
                    : Colors.lightBlue,
              ),
              child: Center(
                child: Text(
                  (widget._tile.correctCoordinate.x *
                              context.read<PuzzleBoard>().size +
                          widget._tile.correctCoordinate.y)
                      .toString(),
                  style: TextStyle(
                    color: widget._tile.isBlankTile
                        ? Colors.black.withOpacity(0.0)
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
