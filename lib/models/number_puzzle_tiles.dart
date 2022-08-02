import 'package:flutter/cupertino.dart';

class NumberPuzzleTiles extends ChangeNotifier {
  int _currentNumberOfTiles;
  NumberPuzzleTiles({int currentNumTiles = 4})
      : _currentNumberOfTiles = currentNumTiles;

  int get currentNumberOfTiles {
    return _currentNumberOfTiles;
  }

  void changeNumberOfTiles(int num) {
    _currentNumberOfTiles = num;
    notifyListeners();
  }
}
