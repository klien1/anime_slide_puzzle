import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/image_wrapper.dart';
import 'package:anime_slide_puzzle/components/game_image_animation.dart';

class GameImageSelector extends StatefulWidget {
  const GameImageSelector({
    Key? key,
    this.width = 150,
    this.height = 150,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  State<GameImageSelector> createState() => _GameImageSelectorState();
}

class _GameImageSelectorState extends State<GameImageSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  // Alignment test = Alignment.topRight;
  bool clicked = true;

  @override
  void initState() {
    super.initState();
    context.read<PuzzleImageSelector>().loadImages();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PuzzleImageSelector puzzleImageSelector =
        context.watch<PuzzleImageSelector>();

    return (puzzleImageSelector.isLoadingImage)
        ? const Text('Loading........')
        : Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int index = 0; index < puzzleImageSelector.length; ++index)
                GameImageAnimation(
                  imageWrapper: puzzleImageSelector.imageList[index],
                  index: index,
                )
            ],
          );
  }
}
