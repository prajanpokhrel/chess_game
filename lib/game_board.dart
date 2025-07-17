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
    newBoard[0][0] = ChessPiece(
      type: chessPieceType.rook,
      isWhite: false,
      imgPath: "assets/images/rook.png",
    );
    newBoard[0][7] = ChessPiece(
      type: chessPieceType.rook,
      isWhite: false,
      imgPath: "assets/images/rook.png",
    );
    newBoard[7][0] = ChessPiece(
      type: chessPieceType.rook,
      isWhite: true,
      imgPath: "assets/images/rook.png",
    );
    newBoard[7][7] = ChessPiece(
      type: chessPieceType.rook,
      isWhite: true,
      imgPath: "assets/images/rook.png",
    );
    // place knight here
    newBoard[0][1] = ChessPiece(
      type: chessPieceType.knight,
      isWhite: false,
      imgPath: "assets/images/Knight.png",
    );
    newBoard[0][6] = ChessPiece(
      type: chessPieceType.knight,
      isWhite: false,
      imgPath: "assets/images/Knight.png",
    );
    newBoard[7][1] = ChessPiece(
      type: chessPieceType.knight,
      isWhite: true,
      imgPath: "assets/images/Knight.png",
    );
    newBoard[7][6] = ChessPiece(
      type: chessPieceType.knight,
      isWhite: true,
      imgPath: "assets/images/Knight.png",
    );
    // place bishop here
    newBoard[0][2] = ChessPiece(
      type: chessPieceType.bishop,
      isWhite: false,
      imgPath: "assets/images/Bishop.png",
    );
    newBoard[0][5] = ChessPiece(
      type: chessPieceType.bishop,
      isWhite: false,
      imgPath: "assets/images/Bishop.png",
    );
    newBoard[7][2] = ChessPiece(
      type: chessPieceType.bishop,
      isWhite: true,
      imgPath: "assets/images/Bishop.png",
    );
    newBoard[7][5] = ChessPiece(
      type: chessPieceType.bishop,
      isWhite: true,
      imgPath: "assets/images/Bishop.png",
    );
    //place queen here
    newBoard[0][3] = ChessPiece(
      type: chessPieceType.queen,
      isWhite: false,
      imgPath: "assets/images/queen.png",
    );
    newBoard[7][4] = ChessPiece(
      type: chessPieceType.queen,
      isWhite: true,
      imgPath: "assets/images/queen.png",
    );

    //place king here
    newBoard[0][4] = ChessPiece(
      type: chessPieceType.king,
      isWhite: false,
      imgPath: "assets/images/king1.png",
    );
    newBoard[7][3] = ChessPiece(
      type: chessPieceType.king,
      isWhite: true,
      imgPath: "assets/images/king1.png",
    );

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
