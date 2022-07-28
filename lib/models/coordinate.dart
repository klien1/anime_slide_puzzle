import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  final int _x;
  final int _y;

  const Coordinate({
    required int x,
    required int y,
  })  : _x = x,
        _y = y;

  int get x {
    return _x;
  }

  int get y {
    return _y;
  }

  Coordinate calculateAdjacent({int x = 0, int y = 0}) {
    return Coordinate(x: _x + x, y: _y + y);
  }

  @override
  List<int> get props => [x, y];
}
