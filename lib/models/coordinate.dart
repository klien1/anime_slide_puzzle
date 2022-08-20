import 'package:equatable/equatable.dart';

enum Direction {
  left,
  right,
  top,
  bottom,
  topRight,
  topLeft,
  bottomRight,
  bottomLeft
}

class Coordinate extends Equatable {
  final int _row;
  final int _col;

  const Coordinate({required int row, required int col})
      : _row = row,
        _col = col;

  int get row {
    return _row;
  }

  int get col {
    return _col;
  }

  int getOneDimensionalArrayIndex(int numRowsOrColumns) {
    return _row * numRowsOrColumns + _col;
  }

  Coordinate calculateAdjacent({
    required Direction direction,
  }) {
    switch (direction) {
      case Direction.top:
        return Coordinate(row: _row - 1, col: _col);
      case Direction.bottom:
        return Coordinate(row: _row + 1, col: _col);
      case Direction.left:
        return Coordinate(row: _row, col: _col - 1);
      case Direction.right:
        return Coordinate(row: _row, col: _col + 1);
      case Direction.topRight:
        return Coordinate(row: _row - 1, col: _col + 1);
      case Direction.topLeft:
        return Coordinate(row: _row - 1, col: _col - 1);
      case Direction.bottomRight:
        return Coordinate(row: _row + 1, col: _col + 1);
      case Direction.bottomLeft:
        return Coordinate(row: _row + 1, col: _col - 1);
      default:
        return Coordinate(row: _row, col: _col);
    }
  }

  @override
  List<int> get props => [row, col];
}
