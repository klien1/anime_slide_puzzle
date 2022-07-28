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

  void move(i) {
    // check if empty

    // notifyListeners();
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
