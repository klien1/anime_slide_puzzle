import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends ChangeNotifier {
  GameTimer();
  GameTimer.initalTime({required int seconds}) : _seconds = seconds;

  Timer? gameTime;
  int _seconds = 0;

  void startTimer() {
    gameTime = Timer.periodic(const Duration(seconds: 1), (timer) {
      ++_seconds;
      notifyListeners();
    });
  }

  void resetTimer() {
    endTimer();
    _seconds = 0;
  }

  void endTimer() {
    gameTime?.cancel();
  }

  String _shouldAddZero(int num) {
    return (num < 10) ? '0$num' : num.toString();
  }

  String get seconds {
    int actualSeconds = _seconds % 60;
    return _shouldAddZero(actualSeconds);
  }

  String get minutes {
    int acutualMinutes = (_seconds ~/ 60) % 60;
    return _shouldAddZero(acutualMinutes);
  }

  String get minutesWithoutHours {
    int acutualMinutes = _seconds ~/ 60;
    return _shouldAddZero(acutualMinutes);
  }

  String get hours {
    int acutalHours = _seconds ~/ 3600;
    return _shouldAddZero(acutalHours);
  }

  String get totalTime {
    return '$hours:$minutes:$seconds';
  }

  String get totalTimeWithoutHours {
    return '$minutesWithoutHours:$seconds';
  }
}
