// import 'package:animated_background/animated_background.dart';
import 'package:anime_slide_puzzle/components/anime_slide_puzzle_title.dart';
import 'package:anime_slide_puzzle/components/background_image.dart';
import 'package:anime_slide_puzzle/components/image_selection/circle_transition_button.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  static String id = 'welcome_screen';

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // precacheImage(AssetImage('images/shooting_star_background.png'), context);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(AssetImage('images/shooting_star_background.png'), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 1,
            child: BackgroundImage(
              imagePath: 'images/shooting_star_background.png',
            ),
          ),
          // AnimatedBackground(
          //     child: AnimeSlidePuzzleTitle(),
          //     vsync: this,
          //     behaviour: RacingLinesBehaviour(direction: LineDirection.Ttb)),
          // AnimatedBackground(
          //   vsync: this,
          //   behaviour: RandomParticleBehaviour(
          //     options: const ParticleOptions(
          //       spawnMaxRadius: 100,
          //       image: Image(
          //         image: AssetImage('images/demon_slayer_logo.png'),
          //       ),
          //     ),
          //   ),
          //   child: AnimeSlidePuzzleTitle(),
          // ),
          CircleTransitionButton(
            destinationScreen: ImageSelectionScreen(),
            buttonText: 'Select a theme',
          ),
        ],
      ),
    );
  }
}
