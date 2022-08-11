import 'package:anime_slide_puzzle/components/anime_slide_puzzle_title.dart';
import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/circle_transition_button.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:anime_slide_puzzle/screens/loading_screen.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      child: (isLoading)
          ? const LoadingScreen()
          : Scaffold(
              body: Stack(
                alignment: Alignment.center,
                children: [
                  const BackgroundImage(
                      imagePath: 'images/horizon_background.jpg'),
                  const Positioned(
                    top: 30,
                    left: 0,
                    child: SizedBox(
                      child: AnimeSlidePuzzleTitle(),
                    ),
                  ),
                  Positioned(
                    top: 250,
                    child: CircleTransitionButton(
                      destinationScreen: const ImageSelectionScreen(),
                      buttonText: 'Choose a theme',
                      buttonStyle: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xFF1b1d29),
                        ),
                      ),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
