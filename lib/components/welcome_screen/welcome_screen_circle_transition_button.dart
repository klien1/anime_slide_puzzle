import 'package:anime_slide_puzzle/components/image_selection/image_selection_components/circle_transition_button.dart';
import 'package:anime_slide_puzzle/screens/image_selection_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreenCircleTransition extends StatelessWidget {
  const WelcomeScreenCircleTransition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleTransitionButton(
      destinationScreen: const ImageSelectionScreen(),
      buttonText: 'Choose a theme',
      buttonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xFF1b1d29),
        ),
      ),
      textStyle: const TextStyle(color: Colors.white),
    );
  }
}
