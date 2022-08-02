import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:anime_slide_puzzle/constants.dart';

const double dimensionOfThumbnail = 150;

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
          height: dimensionOfThumbnail,
          width: dimensionOfThumbnail,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (String path in imageList) getImage(context, path)],
    );
  }
}
