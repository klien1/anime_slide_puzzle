import 'package:anime_slide_puzzle/components/game_image_selector.dart';
import 'package:anime_slide_puzzle/screens/animation_testing.dart';
// import 'package:anime_slide_puzzle/screens/image_test.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  static const String id = 'welcome_screen_id';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            child: const SizedBox(
              // alignment: Alignment.centerRight,
              width: double.infinity,
              height: double.infinity,
              child: Positioned(
                top: 0,
                right: 0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/demon_slayer_background.jpg'),
                      // image: AssetImage('images/spy-x-family-background2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ImageTest()
          // Container(
          //   width: 300,
          //   child: GameImageSelector(
          //     // height: 300,
          //     width: double.infinity,
          //   ),
          // ),
        ],
      ),
    );
  }
}
