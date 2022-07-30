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

  void move({
    required Coordinate clickedTileCoordinate,
  }) {
    final PuzzleTile clickedTile =
        _puzzleTiles2d[clickedTileCoordinate.x][clickedTileCoordinate.y];

    final PuzzleTile blankTile =
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

  void shuffleBoard() {
    for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
      for (PuzzleTile tile in puzzleList) {
        _swapTileCurrentPosition(tile, _getRandomTile());
      }
    }
  }

  void resetBoard() {
    for (List<PuzzleTile> puzzleList in _puzzleTiles2d) {
      for (PuzzleTile tile in puzzleList) {
        tile.currentCoordinate = tile.correctCoordinate;
      }
    }
    notifyListeners();
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
    notifyListeners();
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
