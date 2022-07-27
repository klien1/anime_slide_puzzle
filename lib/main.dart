import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';

const sizeOfPuzzle = 3;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PuzzleBoard(sizeOfPuzzle),
        )
      ],
      child: MaterialApp(
        title: 'Anime Slide Puzzle',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: GameScreen.id,
        routes: {
          GameScreen.id: (context) => const GameScreen(),
        },
      ),
    );
  }
}
