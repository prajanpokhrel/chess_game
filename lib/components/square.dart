import 'package:chess_game/components/piece.dart';
import 'package:flutter/material.dart';

class Square extends StatelessWidget {
  final bool isWhite;
  final bool isSelected;
  final ChessPiece? piece;
  final bool isValid;
  final void Function()? onTap;
  const Square({
    super.key,
    required this.isWhite,
    required this.piece,
    required this.isSelected,
    required this.onTap,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
    if (isSelected) {
      squareColor = Colors.green;
    } else if (isValid) {
      squareColor = Colors.green[300];
    } else {
      squareColor =
          isWhite
              ? Color.fromARGB(255, 53, 52, 52)
              : const Color.fromARGB(255, 110, 107, 107);
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        child:
            piece != null
                ? Image.asset(
                  piece!.imgPath,
                  color: piece!.isWhite ? Colors.white : Colors.black,
                )
                : null,
      ),
    );
  }
}
