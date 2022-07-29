import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:equatable/equatable.dart';

class PuzzleTile extends Equatable {
  final bool _isBlank;
  final Coordinate _correctCoordinate;
  Coordinate currentCoordinate;

  PuzzleTile({
    required Coordinate correctCoordinate,
    required this.currentCoordinate,
    required int index,
    bool isBlank = false,
  })  : _correctCoordinate = correctCoordinate,
        _isBlank = isBlank;

  Coordinate get correctCoordinate {
    return _correctCoordinate;
  }

  bool get isBlankTile {
    return _isBlank;
  }

  @override
  List<Coordinate> get props => [correctCoordinate];
}
