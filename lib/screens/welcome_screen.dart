import 'package:anime_slide_puzzle/components/welcome_screen/anime_slide_puzzle_title.dart';
import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/welcome_screen/welcome_screen_circle_transition_button.dart';
import 'package:anime_slide_puzzle/screens/loading_screen.dart';
import 'package:anime_slide_puzzle/utils/responsive_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/constants.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  static String id = 'welcome_screen';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isLoading = true;

  Future<void> loadingAssets() async {
    Future.delayed(
      const Duration(seconds: 5),
      () => setState(
        () => isLoading = false,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    loadingAssets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(
      const AssetImage('images/horizon_background.jpg'),
      context,
    );

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      precacheImage(
        const AssetImage('images/spy-x-family-background3-no-logo.jpg'),
        context,
      );
    } else {
      precacheImage(
        const AssetImage('images/spy-x-family-background3-no-logo.jpg'),
        context,
      );
    }
  }

  Widget _getLandscapeContent() {
    return Stack(
      alignment: Alignment.center,
      children: const [
        BackgroundImage(imagePath: welcomeScreenImagePath),
        Positioned(
          top: 30,
          child: SizedBox(
            child: Text('Anime Slide Puzzle', style: titleStyle),
          ),
        ),
        Positioned(top: 130, child: WelcomeScreenCircleTransition())
      ],
    );
  }

  Widget _getPortaitContent() {
    return Stack(
      alignment: Alignment.center,
      children: const [
        BackgroundImage(imagePath: welcomeScreenImagePath),
        Positioned(
          top: 30,
          child: AnimeSlidePuzzleTitle(),
        ),
        Positioned(top: 250, child: WelcomeScreenCircleTransition())
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: (isLoading)
          ? const LoadingScreen()
          : Scaffold(
              body: ResponsiveLayout(
                mobile: _getPortaitContent(),
                tablet: _getLandscapeContent(),
                web: _getLandscapeContent(),
              ),
            ),
    );
  }
}
