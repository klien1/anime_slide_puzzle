import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter/cupertino.dart';

import 'package:anime_slide_puzzle/models/puzzle_tile.dart';

class PuzzleBoard extends ChangeNotifier {
  final int _size;
  late List<List<PuzzleTile>> _puzzleTiles2d;

  PuzzleBoard(this._size) {
    _puzzleTiles2d = List.generate(
      _size,
      (row) => List.generate(
        _size,
        (col) => PuzzleTile(
          correctCoordinate: Coordinate(x: row, y: col),
          currentCoordinate: Coordinate(x: row, y: col),
          index: 0,
          isBlank: (row == _size - 1 && col == _size - 1) ? true : false,
        ),
      ),
    );
  }

  void move({
    required Coordinate correctTilePosition,
  }) {
    _swapTwoTiles(correctTilePosition, getBlankTileCoordinate());
  }

  void _swapTwoTiles(
    Coordinate firstCorrectTileCoord,
    Coordinate secondCorrectTileCoord,
  ) {
    final firstTile =
        _puzzleTiles2d[firstCorrectTileCoord.x][firstCorrectTileCoord.y];

    final secondTile =
        _puzzleTiles2d[secondCorrectTileCoord.x][secondCorrectTileCoord.y];

    final temp = firstTile.currentCoordinate;
    firstTile.currentCoordinate = secondTile.currentCoordinate;
    secondTile.currentCoordinate = temp;
    notifyListeners();
  }

  Coordinate getBlankTileCoordinate() {
    return _puzzleTiles2d[_size - 1][_size - 1].correctCoordinate;
  }

  int get size {
    return _size;
  }

  List<List<PuzzleTile>> get puzzleBoard2d {
    return _puzzleTiles2d;
  }
}
