import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:flutter/cupertino.dart';

import 'package:anime_slide_puzzle/models/puzzle_tile.dart';

class PuzzleBoard extends ChangeNotifier {
  final int _size;
  final List<PuzzleTile> _puzzleTiles = [];

  PuzzleBoard(this._size) {
    final numTiles = _size * _size;
    for (int i = 0; i < numTiles - 1; ++i) {
      final Coordinate curCoordinate = Coordinate(x: i ~/ _size, y: i % _size);

      _puzzleTiles.add(
        PuzzleTile(
            correctCoordinate: curCoordinate,
            // currentCoordinate: curCoordinate,
            currentCoordinate: Coordinate(x: 0, y: 0),
            index: i,
            isBlank: (numTiles - 1 == i) ? true : false),
      );
    }
  }

  void swap(i, j) {
    final PuzzleTile temp = _puzzleTiles[i];
    _puzzleTiles[i] = _puzzleTiles[j];
    _puzzleTiles[j] = temp;
    notifyListeners();
  }

  void moveLeft(i) {
    final curX = _puzzleTiles[i].currentCoordinate.x;
    final curY = _puzzleTiles[i].currentCoordinate.y;
    _puzzleTiles[i].currentCoordinate = Coordinate(
      x: curX + 1,
      y: curY,
    );

    print('$curX , $curY');
    notifyListeners();
  }

  int get size {
    return _size;
  }

  List<PuzzleTile> get puzzleBoard {
    return _puzzleTiles;
  }
}
