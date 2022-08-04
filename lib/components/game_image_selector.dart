import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/models/image_wrapper.dart';

class GameImageSelector extends StatelessWidget {
  const GameImageSelector({
    Key? key,
    this.width = 150,
    this.height = 150,
  }) : super(key: key);

  final double width;
  final double height;

  Widget getImage(BuildContext context, ImageWrapper imageWrapper, int index) {
    return GestureDetector(
      onTap: () {
        context.read<PuzzleImageSelector>().changeImage(index);
      },
      child: Image(
        image: imageWrapper.assetImage,
        height: width,
        width: height,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PuzzleImageSelector puzzleImageSelector =
        context.watch<PuzzleImageSelector>();

    return (puzzleImageSelector.isLoadingImage)
        ? Text('Loading........')
        : Column(
            children: [
              for (int index = 0;
                  index < puzzleImageSelector.imageList.length;
                  ++index)
                getImage(context, puzzleImageSelector.imageList[index], index)
            ],
          );
  }
}
