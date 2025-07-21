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

  //initial postion of kings (keep track )
  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  bool checkStatus = false;

  // Game state variables
  bool isGameOver = false;
  String gameResult = "";

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
    newBoard[7][3] = ChessPiece(
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
    newBoard[7][4] = ChessPiece(
      type: chessPieceType.king,
      isWhite: true,
      imgPath: "assets/images/king1.png",
    );

    board = newBoard;
  }

  //User selected piece
  void pieceSelected(int row, int col) {
    // Don't allow moves if game is over
    if (isGameOver) {
      return;
    }

    setState(() {
      // Calculate valid moves BEFORE checking if it's a valid move
      if (selectedPieces != null) {
        vaildMoves = calculateValidMoves(
          selectedRow,
          selectedcol,
          selectedPieces,
          true, // Check for moves that don't put own king in check
        );
      }

      // no piece is selected yet , this is the first selection
      if (selectedPieces == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedPieces = board[row][col];
          selectedRow = row;
          selectedcol = col;
        }
      }
      // if clicking on a piece of the same color, switch selection
      else if (board[row][col] != null &&
          board[row][col]!.isWhite == isWhiteTurn) {
        selectedPieces = board[row][col];
        selectedRow = row;
        selectedcol = col;
      }
      // if there is a pieces selected and user tap on square that is valid moves
      else if (selectedPieces != null &&
          vaildMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
        return; // Early return to avoid recalculating moves after moving
      }

      // Recalculate valid moves for the newly selected piece
      if (selectedPieces != null) {
        vaildMoves = calculateValidMoves(
          selectedRow,
          selectedcol,
          selectedPieces,
          true, // Check for moves that don't put own king in check
        );
      } else {
        vaildMoves = [];
      }
    });
  }

  //calculate a raw valid moves (without considering check)
  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> canidateMoves = [];

    if (piece == null) {
      return [];
    }
    //different direction based on their color
    int direction = piece.isWhite ? -1 : 1;

    switch (piece.type) {
      case chessPieceType.pawn:
        //pawn can move forward if square is empty
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          canidateMoves.add([row + direction, col]);
        }

        //pawn can move 2 square if they are at initial position
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            canidateMoves.add([row + 2 * direction, col]);
          }
        }

        //pawn can kill diagonally - LEFT
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          canidateMoves.add([row + direction, col - 1]);
        }

        //pawn can kill diagonally - RIGHT
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
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
            var newCol = col + i * direction[1];
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

  // Calculate valid moves considering check (filtered moves)
  List<List<int>> calculateValidMoves(
    int row,
    int col,
    ChessPiece? piece,
    bool checkSimulation,
  ) {
    if (piece == null) {
      return [];
    }

    List<List<int>> rawValidMoves = calculateRawValidMoves(row, col, piece);

    // If we don't need to check for simulation (to avoid infinite recursion), return raw moves
    if (!checkSimulation) {
      return rawValidMoves;
    }

    // Filter out moves that would put own king in check
    List<List<int>> realValidMoves = [];

    for (var move in rawValidMoves) {
      int endRow = move[0];
      int endCol = move[1];

      // Simulate the move
      ChessPiece? capturedPiece = board[endRow][endCol];
      board[endRow][endCol] = piece;
      board[row][col] = null;

      // Update king position if the piece being moved is a king
      List<int> originalKingPos =
          piece.isWhite ? [...whiteKingPosition] : [...blackKingPosition];
      if (piece.type == chessPieceType.king) {
        if (piece.isWhite) {
          whiteKingPosition = [endRow, endCol];
        } else {
          blackKingPosition = [endRow, endCol];
        }
      }

      // Check if own king would be in check after this move
      bool wouldBeInCheck = isKingIsCheckIn(piece.isWhite);

      // Restore the king position
      if (piece.type == chessPieceType.king) {
        if (piece.isWhite) {
          whiteKingPosition = originalKingPos;
        } else {
          blackKingPosition = originalKingPos;
        }
      }

      // Undo the move
      board[row][col] = piece;
      board[endRow][endCol] = capturedPiece;

      // If the move doesn't put own king in check, it's a valid move
      if (!wouldBeInCheck) {
        realValidMoves.add(move);
      }
    }

    return realValidMoves;
  }

  // Check if the current player is in checkmate
  bool isCheckMate(bool isWhiteKing) {
    // First check if king is in check
    if (!isKingIsCheckIn(isWhiteKing)) {
      return false; // Not in check, so not checkmate
    }

    // Check if any piece of the current player has valid moves
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves = calculateValidMoves(
          i,
          j,
          board[i][j],
          true,
        );
        if (pieceValidMoves.isNotEmpty) {
          return false; // Found a valid move, not checkmate
        }
      }
    }

    return true; // No valid moves found, it's checkmate
  }

  // Check if the current player is in stalemate
  bool isStaleMate(bool isWhiteKing) {
    // First check if king is NOT in check
    if (isKingIsCheckIn(isWhiteKing)) {
      return false; // In check, so not stalemate
    }

    // Check if any piece of the current player has valid moves
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves = calculateValidMoves(
          i,
          j,
          board[i][j],
          true,
        );
        if (pieceValidMoves.isNotEmpty) {
          return false; // Found a valid move, not stalemate
        }
      }
    }

    return true; // No valid moves found and not in check, it's stalemate
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

    // update king position
    if (selectedPieces!.type == chessPieceType.king) {
      if (selectedPieces!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    // clear selection first
    selectedPieces = null;
    selectedRow = -1;
    selectedcol = -1;
    vaildMoves = [];

    // change turns
    isWhiteTurn = !isWhiteTurn;

    //see if any kings are in attack
    checkStatus = isKingIsCheckIn(isWhiteTurn);

    // Check for checkmate or stalemate
    if (isCheckMate(isWhiteTurn)) {
      isGameOver = true;
      gameResult =
          isWhiteTurn ? "Black Wins by Checkmate!" : "White Wins by Checkmate!";
      _showGameOverDialog();
    } else if (isStaleMate(isWhiteTurn)) {
      isGameOver = true;
      gameResult = "Game Drawn by Stalemate!";
      _showGameOverDialog();
    }
  }

  // Show game over dialog
  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(gameResult),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
              child: Text("New Game"),
            ),
          ],
        );
      },
    );
  }

  // Reset the game
  void _resetGame() {
    setState(() {
      isGameOver = false;
      gameResult = "";
      checkStatus = false;
      isWhiteTurn = true;
      selectedPieces = null;
      selectedRow = -1;
      selectedcol = -1;
      vaildMoves = [];
      whitePicesTaken.clear();
      blackPicesTaken.clear();
      whiteKingPosition = [7, 4];
      blackKingPosition = [0, 4];
      _initializedBoard();
    });
  }

  // is king is check in
  bool isKingIsCheckIn(bool isWhiteKing) {
    // get the position of the king
    List<int> kingPositon = isWhiteKing ? whiteKingPosition : blackKingPosition;
    // check if any enemy pieces can attack the king
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        // skip empty squares and piecs of the same color as the king
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves = calculateRawValidMoves(
          i,
          j,
          board[i][j],
        );
        // check king postion is in this pices valid moves
        if (pieceValidMoves.any(
          (move) => move[0] == kingPositon[0] && move[1] == kingPositon[1],
        )) {
          return true;
        }
      }
    }
    return false;
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

          // Game status
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                if (checkStatus && !isGameOver)
                  Text(
                    'CHECK!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                if (isGameOver)
                  Text(
                    gameResult,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  )
                else
                  Text(
                    isWhiteTurn ? 'White\'s Turn' : 'Black\'s Turn',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ],
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
