import 'package:chess_game/components/dead_pieces.dart';
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
  ChessPiece? selectedPieces;

  // the row indes of selceted pieces
  // -1 means defaut selected pices
  int selectedRow = -1;
  int selectedcol = -1;

  //the list of vald moves for currenctly selected pieces
  //each move is represent with 2 vaue row and col
  List<List<int>> vaildMoves = [];

  //list of white pices taken  by black
  List<ChessPiece> whitePicesTaken = [];

  //list of black pices taken  by white
  List<ChessPiece> blackPicesTaken = [];

  // a boolean to indicate whose tuen it is
  bool isWhiteTurn = true;

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

  //User selected piece
  void pieceSelected(int row, int col) {
    setState(() {
      // no piece is selected yet , this is the first selection
      if (selectedPieces == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPieces = board[row][col];
          selectedRow = row;
          selectedcol = col;
        }
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPieces!.isWhite) {
        selectedPieces = board[row][col];
        selectedRow = row;
        selectedcol = col;
      }
      // if there is a pieces selected and user tap on square that is valid moves
      else if (selectedPieces != null &&
          vaildMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }
      vaildMoves = calculateRawValidMoves(
        selectedRow,
        selectedcol,
        selectedPieces,
      );
    });
  }

  //calculate a raw valid moves
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> canidateMoves = [];

    if (piece == null) {
      return [];
    }
    //different direction based on their color
    int direction = piece!.isWhite ? -1 : 1;
    switch (piece.type) {
      case chessPieceType.pawn:
        //pawn can move forward if square is empty
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          canidateMoves.add([row + direction, col]);
        }

        //pawn can move 2 square if they are at inital postion
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            canidateMoves.add([row + 2 * direction, col]);
          }
        }
        //pawn can kill diagonallly
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          canidateMoves.add([row + direction, col - 1]);
        }
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          canidateMoves.add([row + direction, col + 1]);
        }
        break;
      case chessPieceType.rook:
        //horizonatal and vertical directions
        var directions = [
          [-1, 0], //up
          [1, 0], //down
          [0, -1], //left
          [0, 1], //right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                canidateMoves.add([newRow, newCol]); //kill
              }
              break; //blocked
            }
            canidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case chessPieceType.knight:
        //all eight possible L shapes the knight can move
        var knightMoves = [
          [-2, -1], // up 2 left 1
          [-2, 1], // up 2 right 1
          [-1, -2], // up 1 left 2
          [-1, 2], // up 1 right 2
          [1, -2], // down 1 left 2
          [1, 2], // down 1 right 2
          [2, -1], // down 2 left 1
          [2, 1], // down 2 right 1
        ];
        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              canidateMoves.add([newRow, newCol]); // capture
            }
            continue; // blocked
          }
          canidateMoves.add([newRow, newCol]);
        }
        break;
      case chessPieceType.bishop:
        // diagonal direction
        var directions = [
          [-1, -1], //up left
          [-1, 1], //up right
          [1, -1], // down left
          [1, 1], // down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[0];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                canidateMoves.add([newRow, newCol]); // capture
              }
              break; // block
            }
            canidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case chessPieceType.queen:
        // all eight directions: up, down ,left , rigth and 4 diagonals
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // up left
          [-1, 1], // up  right
          [1, -1], // down  left
          [1, 1], // down right
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                canidateMoves.add([newRow, newCol]); // capture
              }
              break; // blocked
            }
            canidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case chessPieceType.king:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // up left
          [-1, 1], // up  right
          [1, -1], // down  left
          [1, 1], // down right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              canidateMoves.add([newRow, newCol]); // capture
            }
            continue; // blocked
          }
          canidateMoves.add([newRow, newCol]);
        }

        break;
      default:
    }
    return canidateMoves;
  }

  // move pieces
  void movePiece(int newRow, int newCol) {
    //if the new spot has an enemy piece
    if (board[newRow][newCol] != null) {
      //add the captured pieces to the appropriate list
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePicesTaken.add(capturedPiece);
      } else {
        blackPicesTaken.add(capturedPiece);
      }
    }

    // move the peice and clear the old place
    board[newRow][newCol] = selectedPieces;
    board[selectedRow][selectedcol] = null;
    // clear selection
    setState(() {
      selectedPieces = null;
      selectedRow = -1;
      selectedcol = -1;
      vaildMoves = [];
    });
    // change a turns
    isWhiteTurn = !isWhiteTurn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          // white pices taken
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: whitePicesTaken.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder:
                  (context, index) => DeadPieces(
                    imagePath: whitePicesTaken[index].imgPath,
                    isWhite: true,
                  ),
            ),
          ),
          // chess board
          Expanded(
            flex: 3,
            child: GridView.builder(
              itemCount: 8 * 8,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder: (context, index) {
                // get the row and col position
                int row = index ~/ 8;
                int col = index % 8;

                //check if the square is selected
                bool isSelected = selectedRow == row && selectedcol == col;

                // check if the square is valid move
                bool isvalid = false;
                for (var position in vaildMoves) {
                  //comapare row and col
                  if (position[0] == row && position[1] == col) {
                    isvalid = true;
                  }
                }
                return Square(
                  isWhite: isWhite(index),
                  piece: board[row][col],
                  isSelected: isSelected,
                  onTap: () => pieceSelected(row, col),
                  isValid: isvalid,
                );
              },
            ),
          ),
          // black piecs
          Expanded(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: blackPicesTaken.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
              ),
              itemBuilder:
                  (context, index) => DeadPieces(
                    imagePath: blackPicesTaken[index].imgPath,
                    isWhite: false,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
