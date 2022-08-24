import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends ChangeNotifier {
  GameTimer();

  int _seconds = 0;
  int _minutes = 0;
  StreamSubscription<int>? _streamSubscription;
  bool _isTimerInProgress = false;

  void endTimer() {
    _streamSubscription?.cancel();
    _isTimerInProgress = false;
  }

  void startStream() {
    _isTimerInProgress = true;
    _streamSubscription?.cancel();
    _resetTimer();
    _streamSubscription = Stream.periodic(const Duration(seconds: 1), (_) {
      return ++_seconds;
    }).listen((seconds) {
      if (seconds >= 60) {
        _seconds = 0;
        ++_minutes;
      }
      try {
        notifyListeners();
      } catch (e) {
        endTimer();
      }
    });
  }

  void _resetTimer() {
    _seconds = 0;
    _minutes = 0;
  }

  bool get isTimerInProgress {
    return _isTimerInProgress;
  }

  String _shouldAddZero(int num) {
    return (num < 10) ? '0$num' : num.toString();
  }

  String get elapsedTime {
    return '${_shouldAddZero(_minutes)}:${_shouldAddZero(_seconds)}';
  }
}
