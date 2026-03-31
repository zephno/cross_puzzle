class CellPosition {
  final int row;
  final int col;
  const CellPosition(this.row, this.col);
}
 
class Clue {
  final int number;
  final String direction; // 'A' or 'D'
  final CellPosition start;
  final String answer;
  final String hint;
 
  const Clue({
    required this.number,
    required this.direction,
    required this.start,
    required this.answer,
    required this.hint,
  });
 
  String get id => '$number$direction';
  int get length => answer.length;
}
 
class LevelData {
  final String id;
  final String difficulty;
  final List<List<int>> grid; // 1 = white cell, 0 = black cell
  final List<Clue> clues;
 
  const LevelData({
    required this.id,
    required this.difficulty,
    required this.grid,
    required this.clues,
  });
 
  int get rows => grid.length;
  int get cols => grid[0].length;
 
  List<Clue> get acrossClues =>
      clues.where((c) => c.direction == 'A').toList()
        ..sort((a, b) => a.number.compareTo(b.number));
 
  List<Clue> get downClues =>
      clues.where((c) => c.direction == 'D').toList()
        ..sort((a, b) => a.number.compareTo(b.number));
 
  // Returns which clues occupy a given cell
  List<Clue> cluesForCell(int row, int col) {
    return clues.where((clue) {
      if (clue.direction == 'A') {
        return clue.start.row == row &&
            col >= clue.start.col &&
            col < clue.start.col + clue.length;
      } else {
        return clue.start.col == col &&
            row >= clue.start.row &&
            row < clue.start.row + clue.length;
      }
    }).toList();
  }
 
  // Returns the letter index within a clue for a given cell
  int letterIndex(Clue clue, int row, int col) {
    if (clue.direction == 'A') return col - clue.start.col;
    return row - clue.start.row;
  }
}