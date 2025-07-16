import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_function.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          return Square(isWhite: isWhite(index));
        },
      ),
    );
  }
}
