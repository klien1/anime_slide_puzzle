import 'package:anime_slide_puzzle/components/game_board/game_board_components/auto_solve_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/show_hints_button.dart';
import 'package:anime_slide_puzzle/components/game_board/game_board_components/start_game_button.dart';
import 'package:flutter/material.dart';

class GameButtonControls extends StatelessWidget {
  const GameButtonControls({
    Key? key,
    this.spaceBetween = 10,
    this.useColumn = false,
  }) : super(key: key);

  final double spaceBetween;
  final bool useColumn;

  List<Widget> _children() {
    return [
      const StartGameButton(),
      SizedBox(width: spaceBetween, height: spaceBetween),
      const AutoSolveButton(),
      SizedBox(width: spaceBetween, height: spaceBetween),
      const ShowHintsButton(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return (useColumn || constraints.maxWidth < 340)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _children(),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _children(),
              );
      },
    );
  }
}
