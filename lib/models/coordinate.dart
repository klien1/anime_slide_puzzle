import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  final int _row;
  final int _col;

  const Coordinate({
    required int row,
    required int col,
  })  : _row = row,
        _col = col;

  int get row {
    return _row;
  }

  int get col {
    return _col;
  }

  Coordinate calculateAdjacent({int row = 0, int col = 0}) {
    return Coordinate(row: _row + row, col: _col + col);
  }

  @override
  List<int> get props => [row, col];
}
