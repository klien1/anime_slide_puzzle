import 'package:flutter/material.dart';

class PuzzleImageChanger extends ChangeNotifier {
  PuzzleImageChanger(this.curImagePath);

  String curImagePath;

  void changeImage(String path) {
    curImagePath = path;
    notifyListeners();
  }
}
