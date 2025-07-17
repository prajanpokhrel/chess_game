import 'package:chess_game/components/piece.dart';
import 'package:chess_game/components/square.dart';
import 'package:chess_game/helper/helper_function.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  // A 2-d dimenssional list representing the chessboard,
  //with each position contaning a chess pieces

  late List<List<ChessPiece?>> board;
  @override
  void initState() {
    super.initState();
    _initializedBoard();
  }

  void _initializedBoard() {
    //init the boards with nulls , meaning a pieces in thoes position
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    //place pawn here
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: chessPieceType.pawn,
        isWhite: false,
        imgPath: "assets/images/Pawn.png",
      );
      newBoard[6][i] = ChessPiece(
        type: chessPieceType.pawn,
        isWhite: true,
        imgPath: "assets/images/Pawn.png",
      );
    }
    //place rooks here
    // place knight here
    // place bishop here
    //place queen here
    //place king here

    board = newBoard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: 8 * 8,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          // get the row and col position
          int row = index ~/ 8;
          int col = index % 8;
          return Square(isWhite: isWhite(index), piece: board[row][col]);
        },
      ),
    );
  }
}
