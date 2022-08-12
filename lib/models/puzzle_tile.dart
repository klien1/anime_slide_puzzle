import 'package:anime_slide_puzzle/models/coordinate.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PuzzleTile extends Equatable {
  final bool _isBlank;
  final Coordinate _correctCoordinate;
  final int _tileNumber;
  Coordinate currentCoordinate;

  PuzzleTile({
    required Coordinate correctCoordinate,
    required this.currentCoordinate,
    required int tileNumber,
    bool isBlank = false,
  })  : _correctCoordinate = correctCoordinate,
        _isBlank = isBlank,
        _tileNumber = tileNumber;

  Coordinate get correctCoordinate {
    return _correctCoordinate;
  }

  bool get isBlankTile {
    return _isBlank;
  }

  int get tileNumber {
    return _tileNumber;
  }

  @override
  List<Coordinate> get props => [currentCoordinate];
}
