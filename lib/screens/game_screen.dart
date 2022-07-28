import 'package:anime_slide_puzzle/components/game_board.dart';
import 'package:flutter/material.dart';

const double rectHeight = 100;
const double rectWidth = 100;

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  static const String id = 'game_screen_id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: const [
            GameBoard(),
          ],
        ),
      ),
    );
  }
}
