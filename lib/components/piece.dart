enum chessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  final chessPieceType type;
  final bool isWhite;
  final String imgPath;

  ChessPiece({
    required this.type,
    required this.isWhite,
    required this.imgPath,
  });
}
