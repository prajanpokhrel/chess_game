import 'package:chess_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Square({super.key, required this.isWhite, this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isWhite ? Colors.black : Colors.white,
      child:
          piece != null
              ? Image.asset(
                piece!.imgPath,
                color: piece!.isWhite ? Colors.white : Colors.black,
              )
              : null,
    );
  }
}
