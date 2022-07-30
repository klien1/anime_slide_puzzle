import 'package:flutter/material.dart';

class PuzzleImageSelector extends ChangeNotifier {
  PuzzleImageSelector(this.curImagePath);

  String curImagePath;

  void changeImage(String path) {
    curImagePath = path;
    notifyListeners();
  }
}
