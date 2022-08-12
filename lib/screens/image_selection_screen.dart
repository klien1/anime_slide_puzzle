import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_landscape.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_layout/image_selection_layout_portrait.dart';
import 'package:flutter/material.dart';

class ImageSelectionScreen extends StatelessWidget {
  const ImageSelectionScreen({Key? key}) : super(key: key);

  static const String id = 'image_selection_id';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > constraints.maxHeight) {
        return const ImageSelectionLayoutLandscape();
      } else {
        return const ImageSelectionLayoutPortrait();
      }
    });
  }
}
