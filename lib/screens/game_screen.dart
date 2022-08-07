import 'package:anime_slide_puzzle/models/anime_theme.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board.dart';
// import 'package:anime_slide_puzzle/models/number_puzzle_tiles.dart';
// import 'package:anime_slide_puzzle/models/puzzle_board.dart';
// import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/game_button_controls.dart';

const double gameWidth = 500;
const double gameHeight = 500;
const double padding = 3;

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    AnimeTheme animeTheme = context.read<AnimeThemeList>().curAnimeTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SelectBoardSize(),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Hero(
                    tag: 'anime_photo${animeTheme.index}',
                    child: Image(
                      image: AssetImage(animeTheme.logoImagePath),
                    ),
                  ),
                ),
                const GameBoard(
                  width: gameWidth,
                  height: gameHeight,
                  tilePadding: padding,
                ),
                const GameButtonControls(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
