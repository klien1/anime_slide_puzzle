// import 'package:anime_slide_puzzle/components/game_select_board_size.dart';
import 'package:anime_slide_puzzle/components/image_selection_icon.dart';
import 'package:anime_slide_puzzle/models/anime_theme_list.dart';
import 'package:anime_slide_puzzle/models/background_image.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:anime_slide_puzzle/screens/game_screen.dart';
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
  void initState() {
    super.initState();
    // context.read<PuzzleImageSelector>().loadImages();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    AnimeThemeList animeThemeList = context.watch<AnimeThemeList>();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenWidth * .05,
        vertical: screenWidth * .02,
      ),
      // decoration: BoxDecoration(color: Color(0xFF9FC2BA)),
      decoration: BoxDecoration(
          // color: Color(0xFF6094A2),
          color: Colors.white.withOpacity(.20),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black)),
      // color: Colors.white,
      width: 250,
      height: screenHeight,
      // width: screenWidth * .25,
      // height: screenHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Select Theme',
            textAlign: TextAlign.center,
          ),
          for (int i = 0; i < animeThemeList.listLength; ++i)
            Expanded(
              child: GestureDetector(
                onTap: (i == selected)
                    ? null
                    : () {
                        animeThemeList.changeTheme(i);
                        // context
                        //     .read<BackgroundImage>()
                        //     .changeImage(backgroundList[i]);
                        // context.read<PuzzleImageSelector>().changeImage(i);
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: TextButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.pink)),
                onPressed: () {
                  // Navigator.pushNamed(context, GameScreen.id);

                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(seconds: 1),
                      pageBuilder: (_, __, ___) => const GameScreen(),
                    ),
                  );
                },
                child: Text('Start Puzzle')),
          )
        ],
      ),
    );
  }
}
