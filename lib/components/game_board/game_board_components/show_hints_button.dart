import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/show_hints.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowHintsButton extends StatelessWidget {
  const ShowHintsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ShowHints showHints = context.watch<ShowHints>();

    return (context.read<AnimeThemeList>().isLoadingImage)
        ? const SizedBox.shrink()
        : TextButton(
            onPressed: () => showHints.toggleShowHints(),
            child: (showHints.isShowingHints)
                ? const Text('Hide Hints')
                : const Text('Show Hints'),
          );
  }
}
