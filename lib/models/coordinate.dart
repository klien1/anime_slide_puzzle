class Coordinate {
  final int _x;
  final int _y;

  Coordinate({
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

  set x(newX) {
    x = newX;
  }

  set y(newY) {
    y = newY;
  }
}
