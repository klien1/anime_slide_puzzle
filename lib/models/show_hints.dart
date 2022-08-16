import 'package:flutter/cupertino.dart';

class ShowHints extends ChangeNotifier {
  ShowHints();

  bool _isShowingHints = false;

  void toggleShowHints() {
    _isShowingHints = !_isShowingHints;
    notifyListeners();
  }

  bool get isShowingHints {
    return _isShowingHints;
  }
}
