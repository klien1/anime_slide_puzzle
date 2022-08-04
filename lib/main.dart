import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anime Slide Puzzle',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<PuzzleImageSelector>(
        create: (BuildContext context) => PuzzleImageSelector(),
        child: const GameScreen(),
      ),
      // initialRoute: GameScreen.id,
      routes: {
        GameScreen.id: (context) => const GameScreen(),
      },
    );
  }
}
