import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends ChangeNotifier {
  GameTimer();

  int _seconds = 0;
  int _minutes = 0;
  StreamSubscription<int>? _streamSubscription;

  void startTimer() {
    _resetTimer();
    startStream();
  }

  void endTimer() {
    _streamSubscription?.cancel();
  }

  void startStream() {
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
        _streamSubscription?.cancel();
      }
    });
  }

  void _resetTimer() {
    _seconds = 0;
    _minutes = 0;
  }

  String _shouldAddZero(int num) {
    return (num < 10) ? '0$num' : num.toString();
  }

  String get elapsedTime {
    return '${_shouldAddZero(_minutes)}:${_shouldAddZero(_seconds)}';
  }
}
