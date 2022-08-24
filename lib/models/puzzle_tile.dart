import 'package:equatable/equatable.dart';

import 'package:anime_slide_puzzle/models/coordinate.dart';

class PuzzleTile extends Equatable {
  final bool _isBlank;
  final Coordinate _correctCoordinate;
  final int _tileNumber;
  final Coordinate _currentCoordinate;

  const PuzzleTile({
    required Coordinate correctCoordinate,
    required Coordinate currentCoordinate,
    required int tileNumber,
    bool isBlank = false,
  })  : _correctCoordinate = correctCoordinate,
        _currentCoordinate = currentCoordinate,
        _isBlank = isBlank,
        _tileNumber = tileNumber;

  Coordinate get correctCoordinate {
    return _correctCoordinate;
  }

  Coordinate get currentCoordinate {
    return _currentCoordinate;
  }

  bool get isBlankTile {
    return _isBlank;
  }

  int get tileNumber {
    return _tileNumber;
  }

  @override
  List<Coordinate> get props => [_currentCoordinate];

  PuzzleTile copyWith({
    Coordinate? correctCoordinate,
    Coordinate? currentCoordinate,
    int? tileNumber,
    bool? isBlank,
  }) {
    return PuzzleTile(
      correctCoordinate: correctCoordinate ?? this.correctCoordinate,
      currentCoordinate: currentCoordinate ?? this.currentCoordinate,
      tileNumber: tileNumber ?? this.tileNumber,
      isBlank: isBlank ?? isBlankTile,
    );
  }
}
