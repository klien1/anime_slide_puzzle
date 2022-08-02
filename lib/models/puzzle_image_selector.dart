import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/constants.dart';

class PuzzleImageSelector extends ChangeNotifier {
  late String _curImagePath;
  PuzzleImageSelector() {
    _curImagePath = imageList[0];
  }

  String get curImagePath {
    return _curImagePath;
  }

  void changeImage(String path) {
    _curImagePath = path;
    notifyListeners();
  }
}
