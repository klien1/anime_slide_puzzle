import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/models/puzzle_board.dart';
import 'package:provider/provider.dart';

class GameImageSelector extends StatelessWidget {
  const GameImageSelector({Key? key}) : super(key: key);

  Widget getImage(BuildContext context, String path) {
    return GestureDetector(
      onTap: () {
        context.read<PuzzleImageSelector>().changeImage(path);
      },
      child: FittedBox(
        clipBehavior: Clip.hardEdge,
        child: Image(
          image: AssetImage(path),
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getImage(context, 'images/demon_slayer1.jpg'),
            getImage(context, 'images/jujutsu_kaisen.jpg'),
            getImage(context, 'images/spy-x-family.webp'),
            getImage(context, 'images/charmy.gif'),
          ],
        ),
        TextButton(
          onPressed: () {
            context.read<PuzzleBoard>().shuffleBoard();
          },
          child: Text('Random'),
        ),
        TextButton(
          onPressed: () {
            context.read<PuzzleBoard>().resetBoard();
          },
          child: Text('Reset'),
        ),
      ],
    );
  }
}
