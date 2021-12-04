import '../common.dart';

class Number {
  const Number({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}

class Board {
  Board(List<List<int>> board)
      : _currentScore = board.fold(
            0, (acc, row) => acc + row.fold(0, (acc, number) => acc + number)) {
    for (int row = 0; row < 5; row++) {
      for (int column = 0; column < 5; column++) {
        _board[board[row][column]] = Number(row: row, column: column);
      }
    }
  }

  static Board fromLines(List<String> lines) {
    assert(lines.length == 5);
    assert(lines.every((line) => line.length == 3 * 5 - 1));
    return Board([
      for (final line in lines)
        [
          for (int i = 0; i < 5; i++)
            int.parse(line.substring(i * 3, i == 4 ? null : (i + 1) * 3)),
        ]
    ]);
  }

  final _board = List<Number?>.filled(100, null);

  void markIfNeeded(int draw) {
    final index = _board[draw];
    if (index == null) return;
    _currentScore -= draw;
    _rowCounts[index.row] -= 1;
    _columnCounts[index.column] -= 1;
    _hasWon = _rowCounts[index.row] == 0 || _columnCounts[index.column] == 0;
  }

  int _currentScore;
  int get currentScore => _currentScore;

  final _rowCounts = List.filled(5, 5);
  final _columnCounts = List.filled(5, 5);

  bool _hasWon = false;
  bool get hasWon => _hasWon;
}

class Input {
  Input({
    required this.drawOrder,
    required this.boards,
  });
  final List<int> drawOrder;
  final List<Board> boards;

  static Input fromLines(List<String> lines) {
    assert((lines.length - 1) % 6 == 0);
    final numBoards = lines.length ~/ 6;
    return Input(
      drawOrder: lines[0].split(',').map(int.parse).toList(),
      boards: [
        for (int i = 0; i < numBoards; i++)
          Board.fromLines([
            for (int l = 2 + i * 6; l < 1 + (i + 1) * 6; l++) lines[l],
          ]),
      ],
    );
  }
}

final part1 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    for (final draw in input.drawOrder) {
      for (final board in input.boards) {
        board.markIfNeeded(draw);
      }
      final winnerBoard =
          input.boards.firstWhereOrNull((board) => board.hasWon);
      if (winnerBoard == null) continue;
      print('Board won at $draw with score: ${winnerBoard.currentScore}');
      return '${winnerBoard.currentScore * draw}';
    }
    return 'No board won';
  },
);

final part2 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    var boards = input.boards;
    for (final draw in input.drawOrder) {
      for (final board in boards) {
        board.markIfNeeded(draw);
      }
      if (boards.length > 1) {
        boards = boards.where((b) => !b.hasWon).toList();
      }
      if (boards.length > 1) continue;
      assert(boards.length == 1);
      if (!boards[0].hasWon) continue;
      print(
          'Last board to win, wins at $draw with score: ${boards[0].currentScore}');
      return '${boards[0].currentScore * draw}';
    }
    return 'No board won';
  },
);
