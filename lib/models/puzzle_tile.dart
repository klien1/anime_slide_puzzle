import 'package:anime_slide_puzzle/models/coordinate.dart';

class PuzzleTile {
  final bool _isBlank;
  final Coordinate _correctCoordinate;
  Coordinate _currentCoordinate;

  PuzzleTile({
    required Coordinate correctCoordinate,
    required Coordinate currentCoordinate,
    required int index,
    bool isBlank = false,
  })  : _correctCoordinate = correctCoordinate,
        _currentCoordinate = currentCoordinate,
        _isBlank = isBlank;

  Coordinate get correctCoordinate {
    return _correctCoordinate;
  }

  Coordinate get currentCoordinate {
    return _currentCoordinate;
  }

  set currentCoordinate(Coordinate newCoordinate) {
    _currentCoordinate = newCoordinate;
  }

  // TODO: Remove after testing
  String get tileText {
    return _isBlank ? '' : '${_correctCoordinate.x} ${_correctCoordinate.y}';
  }

  bool get isBlankTile {
    return _isBlank;
  }
}
