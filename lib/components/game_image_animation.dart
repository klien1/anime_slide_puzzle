import 'package:anime_slide_puzzle/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:anime_slide_puzzle/models/image_wrapper.dart';
import 'package:anime_slide_puzzle/models/puzzle_image_selector.dart';
import 'package:provider/provider.dart';

class GameImageAnimation extends StatefulWidget {
  const GameImageAnimation({
    Key? key,
    required this.imageWrapper,
    required this.index,
    this.height = 150,
    this.width = 150,
  }) : super(key: key);

  final double width;
  final double height;
  final ImageWrapper imageWrapper;
  final int index;

  @override
  State<GameImageAnimation> createState() => _GameImageAnimationState();
}

class _GameImageAnimationState extends State<GameImageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> flexAnimation;

  late Animation<double> heightAnimation;

  late double animatedHeight;
  int flexValue = 1;

  @override
  void initState() {
    super.initState();

    animatedHeight = widget.height;

    animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    flexAnimation = IntTween(begin: 1, end: 2).animate(animationController);
    flexAnimation.addListener(() => setState(() {}));

    heightAnimation = Tween<double>(begin: widget.height, end: 800
            //MediaQuery.of(context).size.height
            )
        .animate(animationController);
    // StepTween(begin: widget.height.floor(), end: double.infinity.floor())
    //     .animate(animationController);
    heightAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          // context.read<PuzzleImageSelector>().changeImage(widget.index);
          Navigator.pushNamed(context, GameScreen.id);
        },
        child: MouseRegion(
          onEnter: (event) => setState(() {
            // animatedHeight = double.infinity;
            animationController.forward();
          }),
          onExit: (event) => setState(() {
            // animatedHeight = widget.height;
            animationController.reverse();
          }),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: Image(
              key: UniqueKey(),
              image: widget.imageWrapper.assetImage,
              width: widget.width,
              height: heightAnimation.value,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
