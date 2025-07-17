import 'package:chess_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? piece;
  const Square({super.key, required this.isWhite, this.piece});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          isWhite
              ? const Color.fromARGB(255, 53, 52, 52)
              : const Color.fromARGB(255, 110, 107, 107),
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
