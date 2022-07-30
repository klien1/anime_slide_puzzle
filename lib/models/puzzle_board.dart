import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter/cupertino.dart';
import 'package:anime_slide_puzzle/models/puzzle_tile.dart';
import 'dart:math';

class PuzzleBoard extends ChangeNotifier {
  final int _numRowsOrColumns;
  late List<List<PuzzleTile>> _puzzleTiles2d;

  PuzzleBoard(this._numRowsOrColumns) {
    _puzzleTiles2d = List.generate(
      _numRowsOrColumns,
      (row) => List.generate(
        _numRowsOrColumns,
        (col) => PuzzleTile(
          correctCoordinate: Coordinate(x: row, y: col),
          currentCoordinate: Coordinate(x: row, y: col),
          index: 0,
          tileNumber: row * _numRowsOrColumns + col,
          isBlank:
              (row == _numRowsOrColumns - 1 && col == _numRowsOrColumns - 1)
                  ? true
                  : false,
        ),
      ),
    );
  }

  void moveTile({
    required Coordinate clickedTileCoordinate,
  }) {
    final PuzzleTile clickedTile =
        _puzzleTiles2d[clickedTileCoordinate.x][clickedTileCoordinate.y];

    final PuzzleTile blankTile =
        _puzzleTiles2d[blankTileCoordinate.x][blankTileCoordinate.y];

    if (_isAdjacentToEmptyTile(clickedTile)) {
      _swapTileCurrentPosition(clickedTile, blankTile);
      notifyListeners();
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

  void shuffleBoard() {
    do {
      for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
        for (PuzzleTile tile in puzzleList) {
          _swapTileCurrentPosition(tile, _getRandomTile());
        }
      }
    } while (!_isPuzzleIsSolvable());
    notifyListeners();
  }

  void resetBoard() {
    for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
      for (PuzzleTile tile in puzzleList) {
        tile.currentCoordinate = tile.correctCoordinate;
      }
    }
    notifyListeners();
  }

  bool _isPuzzleIsSolvable() {
    // Count # of inversions
    // An inversion is any pair of tiles i and j where i < j
    // but i appears after j when considering the board in row-major order

    // create an array with tile values
    // first initialize array size and blankTileRow

    late int blankTileRow;
    List<int> tileValues1d =
        List.generate(_numRowsOrColumns * _numRowsOrColumns, (index) => -1);

    // assign tile numbes to array and get blank tile row #
    for (int row = 0; row < _numRowsOrColumns; ++row) {
      for (int col = 0; col < _numRowsOrColumns; ++col) {
        final curTile = _puzzleTiles2d[row][col];
        Coordinate curTileCoord = curTile.currentCoordinate;

        tileValues1d[curTileCoord.y + curTileCoord.x * _numRowsOrColumns] =
            curTile.tileNumber;

        if (curTile.tileNumber == (_numRowsOrColumns * _numRowsOrColumns - 1)) {
          blankTileRow = curTile.currentCoordinate.x;
        }
      }
    }

    int numInversions = 0;
    for (int i = 0; i < tileValues1d.length; ++i) {
      final curVal = tileValues1d[i];
      for (int j = i + 1; j < tileValues1d.length; ++j) {
        // skip inversion count if blank tile
        if (curVal == (_numRowsOrColumns * _numRowsOrColumns - 1)) continue;
        if (curVal > tileValues1d[j]) ++numInversions;
      }
    }

    if ((!_isEven(_numRowsOrColumns) && _isEven(numInversions)) ||
        _isEven(_numRowsOrColumns) && !_isEven(numInversions + blankTileRow)) {
      return true;
    }

    return false;
  }

  bool _isEven(int num) {
    return num % 2 == 0;
  }

  PuzzleTile _getRandomTile() {
    Random rng = Random();
    return _puzzleTiles2d[rng.nextInt(_numRowsOrColumns)]
        [rng.nextInt(_numRowsOrColumns)];
  }

  void _swapTileCurrentPosition(
    PuzzleTile firstTile,
    PuzzleTile secondTile,
  ) {
    if (firstTile == secondTile) return;

    final temp = firstTile.currentCoordinate;
    firstTile.currentCoordinate = secondTile.currentCoordinate;
    secondTile.currentCoordinate = temp;
    // notifyListeners();
  }

  Coordinate get blankTileCoordinate {
    return _puzzleTiles2d[_numRowsOrColumns - 1][_numRowsOrColumns - 1]
        .correctCoordinate;
  }

  int get numRowsOrColumns {
    return _numRowsOrColumns;
  }

  List<List<PuzzleTile>> get puzzleBoard2d {
    return _puzzleTiles2d;
  }
}
