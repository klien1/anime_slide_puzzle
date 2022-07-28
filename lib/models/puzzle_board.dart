import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter/cupertino.dart';

import 'package:anime_slide_puzzle/models/puzzle_tile.dart';

class PuzzleBoard extends ChangeNotifier {
  final int _size;
  // final List<PuzzleTile> _puzzleTiles = [];
  late List<List<PuzzleTile>> _puzzleTiles2d;

  PuzzleBoard(this._size) {
    // final numTiles = _size * _size;
    // for (int i = 0; i < numTiles - 1; ++i) {
    //   final Coordinate curCoordinate = Coordinate(x: i ~/ _size, y: i % _size);

    //   _puzzleTiles.add(
    //     PuzzleTile(
    //         correctCoordinate: curCoordinate,
    //         // currentCoordinate: curCoordinate,
    //         currentCoordinate: curCoordinate,
    //         index: i,
    //         isBlank: (numTiles - 1 == i) ? true : false),
    //   );
    // }

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
    // int horizontal = 0,
    // int vertical = 0,
  }) {
    // move
    // curTile.currentCoordinate = Coordinate(
    //   x: currentPositionX + vertical,
    //   y: currentPositionY + horizontal,
    // );
    _swapTwoTiles(correctTilePosition, getBlankTileCoordinate());

    // check if empty
  }

  void _swapTwoTiles(
    Coordinate firstCorrectTileCoord,
    Coordinate secondCurrentTileCoord,
  ) {
    final firstTile =
        _puzzleTiles2d[firstCorrectTileCoord.x][firstCorrectTileCoord.y];

    final secondTile =
        _puzzleTiles2d[secondCurrentTileCoord.x][secondCurrentTileCoord.y];

    final temp = firstTile.currentCoordinate;
    firstTile.currentCoordinate = secondTile.currentCoordinate;
    secondTile.currentCoordinate = temp;
    notifyListeners();
    printState('after');
  }

  Coordinate getBlankTileCoordinate() {
    // printState('before');
    return _puzzleTiles2d[_size - 1][_size - 1].correctCoordinate;
  }

  void printState(String message) {
    print(message);
    print('current');
    for (List<PuzzleTile> puzzleTileList in _puzzleTiles2d) {
      String s = '';
      for (PuzzleTile tile in puzzleTileList) {
        s += '(${tile.currentCoordinate.x}, ${tile.currentCoordinate.y}) ';
      }
      print(s);
    }

    print('correct');
    for (List<PuzzleTile> puzzleTileList in _puzzleTiles2d) {
      String s = '';
      for (PuzzleTile tile in puzzleTileList) {
        s += '(${tile.correctCoordinate.x}, ${tile.correctCoordinate.y}) ';
      }
      print(s);
    }
  }
  // void swap(i, j) {
  //   final PuzzleTile temp = _puzzleTiles[i];
  //   _puzzleTiles[i] = _puzzleTiles[j];
  //   _puzzleTiles[j] = temp;
  //   notifyListeners();
  // }

  // void _moveLeft(i) {
  //   final curPositionX = _puzzleTiles[i].currentCoordinate.x;
  //   final curPositionY = _puzzleTiles[i].currentCoordinate.y;

  //   _puzzleTiles[i].currentCoordinate = Coordinate(
  //     x: curPositionX,
  //     y: curPositionY - 1,
  //   );
  // }

  // void _moveRight(i) {
  //   final curPositionX = _puzzleTiles[i].currentCoordinate.x;
  //   final curPositionY = _puzzleTiles[i].currentCoordinate.y;

  //   _puzzleTiles[i].currentCoordinate = Coordinate(
  //     x: curPositionX,
  //     y: curPositionY + 1,
  //   );
  // }

  // void _moveUp(i) {
  //   final curPositionX = _puzzleTiles[i].currentCoordinate.x;
  //   final curPositionY = _puzzleTiles[i].currentCoordinate.y;

  //   _puzzleTiles[i].currentCoordinate = Coordinate(
  //     x: curPositionX - 1,
  //     y: curPositionY,
  //   );
  // }

  // void _moveDown(i) {
  //   final curPositionX = _puzzleTiles[i].currentCoordinate.x;
  //   final curPositionY = _puzzleTiles[i].currentCoordinate.y;

  //   _puzzleTiles[i].currentCoordinate = Coordinate(
  //     x: curPositionX + 1,
  //     y: curPositionY,
  //   );
  // }

  int get size {
    return _size;
  }

  // List<PuzzleTile> get puzzleBoard {
  //   return _puzzleTiles;
  // }

  List<List<PuzzleTile>> get puzzleBoard2d {
    return _puzzleTiles2d;
  }
}
