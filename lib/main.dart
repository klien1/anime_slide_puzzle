import 'package:anime_slide_puzzle/constants.dart';
import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:anime_slide_puzzle/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _animeThemeData(AnimeTheme animeTheme) {
    return ThemeData(
      primarySwatch: animeTheme.primarySwatch,
      scaffoldBackgroundColor: animeTheme.backgroundColor,
      iconTheme: IconThemeData(color: animeTheme.bodyText2Color, size: 25),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: animeTheme.elevatedButtonPrimary,
          onPrimary: animeTheme.elevatedButtonOnPrimary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: animeTheme.textButtonPrimary,
          backgroundColor: animeTheme.textButtonBackgroundColor,
          elevation: 2,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(
          color: animeTheme.bodyText2Color,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontFamily: 'JosefinSans',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalProviers = [
      ChangeNotifierProvider<AnimeThemeList>(
          create: (context) => AnimeThemeList(animeImageList: animeImageList),
          builder: (context, child) {
            final AnimeTheme animeTheme =
                context.select<AnimeThemeList, AnimeTheme>(
              (animeThemeList) => animeThemeList.curAnimeTheme,
            );
            return MaterialApp(
              title: 'Anime Slide Puzzle',
              theme: _animeThemeData(animeTheme),
              home: const Welcome(),
            );
          }),
    ];

    return MultiProvider(providers: globalProviers);
  }
}
