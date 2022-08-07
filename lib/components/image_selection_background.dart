import 'package:flutter/material.dart';
// import 'package:anime_slide_puzzle/components/image_selection_background.dart';
import 'package:anime_slide_puzzle/models/background_image.dart';
import 'package:provider/provider.dart';

class ImageSelectionBackground extends StatelessWidget {
  const ImageSelectionBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BackgroundImage backgroundImage = context.watch<BackgroundImage>();
    // print(backgroundImage.curImagePath);

    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: backgroundImage.getCurrentBackgroundImage(),
      // child: SizedBox(
      //   // alignment: Alignment.centerRight,
      //   width: double.infinity,
      //   height: double.infinity,
      //   child: DecoratedBox(
      //     key: UniqueKey(),
      //     decoration: BoxDecoration(
      //       image: DecorationImage(
      //         image: AssetImage(backgroundImage.curImagePath),
      //         // source: https://wall.alphacoders.com/big.php?i=1143485
      //         // image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
      //         // image: AssetImage('images/demon_slayer_background.jpg'),
      //         // source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
      //         // image: AssetImage('images/spy-x-family-background2.jpg'),
      //         // source: https://wall.alphacoders.com/big.php?i=1227567
      //         fit: BoxFit.cover,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
