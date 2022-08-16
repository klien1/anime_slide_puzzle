import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBoardReferenceImage extends StatelessWidget {
  const GameBoardReferenceImage({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final String assetName = context.read<AnimeThemeList>().curPuzzle;
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => const _ReferenceImageDialog(),
        );
      },
      child: Container(
        constraints: BoxConstraints(minWidth: width, minHeight: height),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black)),
        width: width,
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(assetName),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ReferenceImageDialog extends StatelessWidget {
  const _ReferenceImageDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width * .8;
    final double screenHeight = MediaQuery.of(context).size.height * .8;

    return Dialog(
        child: Container(
      width: (screenWidth < screenHeight) ? screenWidth : screenHeight,
      height: (screenWidth < screenHeight) ? screenWidth : screenHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF737372),
        image: DecorationImage(
          image: AssetImage(context.read<AnimeThemeList>().curPuzzle),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
