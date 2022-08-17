import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:flutter/material.dart';

class AnimeThemeList extends ChangeNotifier {
  AnimeThemeList({required Map<String, Map<String, Object>> animeImageList}) {
    int i = 0;
    animeImageList.forEach(
      (animeName, animeImage) => _animeThemeList.add(
        AnimeTheme(
          name: animeName,
          logoImagePath: animeImage['logo'].toString(),
          backgroundImagePath: animeImage['background'].toString(),
          puzzleImagePath: animeImage['puzzle'].toString(),
          puzzleBackgroundImagePath: animeImage['puzzleBackground']?.toString(),
          primarySwatch: animeImage['primarySwatch'] as MaterialColor,
          backgroundColor: _tryToCast<Color>(animeImage['backgroundColor']),
          textButtonPrimary: _tryToCast<Color>(animeImage['textButtonPrimary']),
          textButtonBackgroundColor:
              _tryToCast<Color>(animeImage['textButtonBackgroundColor']),
          elevatedButtonPrimary:
              _tryToCast<Color>(animeImage['elevatedButtonPrimary']),
          elevatedButtonOnPrimary:
              _tryToCast<Color>(animeImage['elevatedButtonOnPrimary']),
          bodyText2Color: _tryToCast<Color>(animeImage['bodyText2Color']),
          index: i++,
        ),
      ),
    );
    _curLogo = _animeThemeList[0].logoImagePath;
    _curBackground = _animeThemeList[0].backgroundImagePath;
    _curPuzzle = _animeThemeList[0].puzzleImagePath;
    _curPuzzleBackground = _animeThemeList[0].puzzleBackgroundImagePath;
    isLoadingImage = false;
    notifyListeners();
  }

  bool isLoadingImage = true;
  int _curIndex = 0;
  final List<AnimeTheme> _animeThemeList = [];
  late String _curLogo;
  late String _curBackground;
  late String _curPuzzle;
  String? _curPuzzleBackground;

  void changeTheme(int index) {
    if (index < 0 || index >= _animeThemeList.length) return;
    _curIndex = index;
    _curLogo = _animeThemeList[index].logoImagePath;
    _curBackground = _animeThemeList[index].backgroundImagePath;
    _curPuzzle = _animeThemeList[index].puzzleImagePath;
    _curPuzzleBackground = _animeThemeList[index].puzzleBackgroundImagePath;
    notifyListeners();
  }

  AnimeTheme getAnimeThemeAtIndex(int index) {
    return _animeThemeList[index];
  }

  T? _tryToCast<T>(dynamic object) => object is T ? object : null;

  Color get color {
    return Colors.black;
  }

  int get listLength {
    return _animeThemeList.length;
  }

  String get curLogo {
    return _curLogo;
  }

  String get curBackground {
    return _curBackground;
  }

  String get curPuzzle {
    return _curPuzzle;
  }

  String? get curPuzzleBackground {
    return _curPuzzleBackground;
  }

  AnimeTheme get curAnimeTheme {
    return _animeThemeList[_curIndex];
  }

  int get curIndex {
    return _curIndex;
  }
}
