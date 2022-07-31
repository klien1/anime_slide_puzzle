import 'package:flutter/cupertino.dart';

class TileNumberOpacity extends ChangeNotifier {
  double _currentOpacity = 0;
  bool isVisible = false;

  void toggleShowNumber() {
    isVisible = !isVisible;
    _currentOpacity = (isVisible) ? 1 : 0;
    notifyListeners();
  }

  double get currentOpacity {
    return _currentOpacity;
  }
}
