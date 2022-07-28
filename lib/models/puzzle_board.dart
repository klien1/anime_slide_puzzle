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
    required Coordinate clickedTileCoordinate,
  }) {
    final clickedTile =
        _puzzleTiles2d[clickedTileCoordinate.x][clickedTileCoordinate.y];

    final blankTile =
        _puzzleTiles2d[blankTileCoordinate.x][blankTileCoordinate.y];

    if (_isAdjacentToEmptyTile(clickedTile)) {
      _swapTileCurrentPosition(clickedTile, blankTile);
    }
  }

  bool _isAdjacentToEmptyTile(PuzzleTile curTile) {
    Coordinate currentBlankTileCoordinate =
        _puzzleTiles2d[blankTileCoordinate.x][blankTileCoordinate.y]
            .currentCoordinate;

    return curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(x: 1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(x: -1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(y: 1) ||
        curTile.currentCoordinate ==
            currentBlankTileCoordinate.calculateAdjacent(y: -1);
  }

  void _swapTileCurrentPosition(
    PuzzleTile firstTile,
    PuzzleTile secondTile,
  ) {
    final temp = firstTile.currentCoordinate;
    firstTile.currentCoordinate = secondTile.currentCoordinate;
    secondTile.currentCoordinate = temp;
    notifyListeners();
  }

  Coordinate get blankTileCoordinate {
    return _puzzleTiles2d[_size - 1][_size - 1].correctCoordinate;
  }

  int get size {
    return _size;
  }

  List<List<PuzzleTile>> get puzzleBoard2d {
    return _puzzleTiles2d;
  }
}
