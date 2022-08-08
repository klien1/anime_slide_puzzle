import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/image_selection_icon.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// source: https://wall.alphacoders.com/big.php?i=1143485
// image: AssetImage('images/jujutsu_kaisen_background2.jpg'),
// image: AssetImage('images/demon_slayer_background.jpg'),
// source: https://wallpapersden.com/demon-slayer-4k-gaming-wallpaper/
// image: AssetImage('images/spy-x-family-background2.jpg'),
// source: https://wall.alphacoders.com/big.php?i=1227567

class ImageSelectionBar extends StatefulWidget {
  const ImageSelectionBar({Key? key}) : super(key: key);

  @override
  State<ImageSelectionBar> createState() => _ImageSelectionBarState();
}

class _ImageSelectionBarState extends State<ImageSelectionBar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * .05,
        vertical: screenHeight * .05,
      ),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      width: 200,
      height: screenHeight * .7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < animeThemeList.listLength; ++i)
            Expanded(
              child: GestureDetector(
                onTap: (i == selected)
                    ? null
                    : () {
                        animeThemeList.changeTheme(i);
                        setState(() {
                          selected = i;
                        });
                      },
                child: ImageSelectionIcon(
                  imagePath:
                      animeThemeList.getAnimeThemeAtIndex(i).logoImagePath,
                  isSelected: (selected == i) ? true : false,
                  index: i,
                ),
              ),
            ),
          const SizedBox(height: 20),
          const SelectBoardSize(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
