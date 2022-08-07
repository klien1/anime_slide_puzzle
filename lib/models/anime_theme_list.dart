import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:flutter/cupertino.dart';
// import 'package:anime_slide_puzzle/constants.dart';

class AnimeThemeList extends ChangeNotifier {
  AnimeThemeList({
    required Map<String, Map<String, String>> animeImageList,
  }) {
    int i = 0;
    animeImageList.forEach(
      (animeName, animeImage) => _animeThemeList.add(
        AnimeTheme(
          logoImagePath: animeImage['logo']!,
          backgroundImagePath: animeImage['background']!,
          puzzleImagePath: animeImage['puzzle']!,
          index: i++,
        ),
      ),
    );
    _curLogo = _animeThemeList[0].logoImagePath;
    _curBackground = _animeThemeList[0].backgroundImagePath;
    _curPuzzle = _animeThemeList[0].puzzleImagePath;
    isLoadingImage = false;
    notifyListeners();
  }

  bool isLoadingImage = true;
  int _curIndex = 0;
  final List<AnimeTheme> _animeThemeList = [];
  late String _curLogo;
  late String _curBackground;
  late String _curPuzzle;

  void changeTheme(int index) {
    // print('changing theme');
    if (index < 0) return;
    _curIndex = index;
    _curLogo = _animeThemeList[index].logoImagePath;
    _curBackground = _animeThemeList[index].backgroundImagePath;
    _curPuzzle = _animeThemeList[index].puzzleImagePath;
    notifyListeners();
  }

  AnimeTheme getAnimeThemeAtIndex(int index) {
    return _animeThemeList[index];
  }

  SizedBox getCurrentBackgroundImage() {
    return SizedBox(
      key: UniqueKey(),
      width: double.infinity,
      height: double.infinity,
      child: DecoratedBox(
        key: UniqueKey(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_curBackground),
            // source: https://wall.alphacoders.com/big.php?i=1143485
            // image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
            // image: AssetImage('images/demon_slayer_background.jpg'),
            // source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
            // image: AssetImage('images/spy-x-family-background2.jpg'),
            // source: https://wall.alphacoders.com/big.php?i=1227567
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
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

  AnimeTheme get curAnimeTheme {
    return _animeThemeList[_curIndex];
  }
}
