bool isWhite(int index) {
  int x = index ~/ 8; // for row
  int y = index % 8; // for column

  // alteranate a color for each square
  bool isWhite = (x + y) % 2 == 0;
  return isWhite;
}

bool isInBoard(int row, int col) {
  return row >= 0 && row < 8 && col >= 0 && col < 8;
}
