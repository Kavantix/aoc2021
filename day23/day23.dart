import 'dart:collection';
import 'dart:io';

import '../common.dart';

const amphipods = 'ABCD';
const costs = [1, 10, 100, 1000];
const correctRooms = [2, 4, 6, 8];

class Cell {
  Amphipod? occupant;
  bool get isOccupied => occupant != null;
  bool get isNotOccupied => occupant == null;
}

class Board {
  Board(List<List<String>> input) {
    for (final y in [1, 2]) {
      for (final x in correctRooms) {
        cells[y][x]!.occupant = Amphipod(
          name: input[y][x],
          cost: costs['ABCD'.indexOf(input[y][x])],
          x: x,
          y: y,
          correctRoom: correctRooms['ABCD'.indexOf(input[y][x])],
        );
      }
    }
    minRequiredCost = cells
        .flatten()
        .where((c) => c != null && c.isOccupied)
        .map((c) => c!.occupant!.minRequiredCost =
            c.occupant!.cost * (c.occupant!.correctRoom - c.occupant!.x).abs() +
                (c.occupant!.isInCorrectRoom
                    ? 0
                    : (c.occupant!.y + 1) * c.occupant!.cost))
        .sum();
  }
  final movedAmphipods = Queue<Amphipod>();

  int minRequiredCost = 0;

  final cells = [
    for (final y in range(3))
      <Cell?>[
        for (final x in range(11))
          y == 0 || correctRooms.contains(x) ? Cell() : null,
      ]
  ];
  final moves = Queue<Move>();
  int cost = 0;

  // List<Move> get possibleMoves => [
  //       for (int y = 0; y < 3; y++)
  //         for (int x = 0; x < 11; x++)
  //           if (amphipods.contains(cells[y][x]))
  //             ...() {
  //               final cost = costs[amphipods.indexOf(cells[y][x])];
  //               return [
  //                 if (x > 0 && cells[y][x - 1] == '.')
  //                   Move(x, y, x - 1, y, cost),
  //                 if (x < 10 && cells[y][x + 1] == '.')
  //                   Move(x, y, x + 1, y, cost),
  //                 if (y > 0 && cells[y - 1][x] == '.')
  //                   Move(x, y, x, y - 1, cost),
  //                 if (y < 2 && cells[y + 1][x] == '.')
  //                   Move(x, y, x, y + 1, cost),
  //               ];
  //             }(),
  //     ];

  bool get isFinished => cells.flatten().every(
      (c) => c == null || c.isNotOccupied || c.occupant!.isInCorrectRoom);
  // cells[1][2] == 'A' &&
  // cells[1][4] == 'B' &&
  // cells[1][6] == 'C' &&
  // cells[2][2] == 'A' &&
  // cells[1][8] == 'D' &&
  // cells[2][4] == 'B' &&
  // cells[2][6] == 'C' &&
  // cells[2][8] == 'D';
}

class Move {
  Move(
    this.fromX,
    this.fromY,
    this.toX,
    this.toY,
  );

  final int fromX, fromY;
  final int toX, toY;

  bool isLocking = false;
  int? cost;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Move &&
      other.fromX == fromX &&
      other.fromY == fromY &&
      other.toX == toX &&
      other.toY == toY;

  @override
  String toString() => '($fromX,$fromY -> $toX,$toY)';

  void perform(Board board) {
    assert(board.cells[toY][toX]!.occupant == null,
        'Only move to empty spaces, $this');
    assert(board.cells[fromY][fromX]!.occupant != null,
        'Only move amphipods, $this');
    final cell = board.cells[fromY][fromX]!;
    final amphipod = cell.occupant!;
    // print(amphipod);
    board.cost += cost ?? amphipod.cost;
    amphipod.consumedEnergy += cost ?? amphipod.cost;
    board.minRequiredCost -= amphipod.minRequiredCost;
    board.cells[toY][toX]!.occupant = amphipod;
    amphipod.previousPosisitions.add(Point(fromX, fromY));
    if (isLocking) {
      assert(!amphipod.locked);
      amphipod.locked = true;
    }
    amphipod.x = toX;
    amphipod.y = toY;
    cell.occupant = null;
    board.movedAmphipods.add(amphipod);
    board.moves.add(this);
    // printBoard(board);
  }

  void undo(Board board) {
    assert(board.cells[fromY][fromX]!.occupant == null,
        'Only move to empty spaces');
    assert(board.cells[toY][toX]!.occupant != null, 'Only move amphipods');
    assert(board.moves.last == this);
    final cell = board.cells[toY][toX]!;
    final amphipod = cell.occupant!;
    assert(board.moves.last == this);
    board.cost -= cost ?? amphipod.cost;
    amphipod.consumedEnergy -= cost ?? amphipod.cost;
    board.minRequiredCost += amphipod.minRequiredCost;
    board.cells[fromY][fromX]!.occupant = amphipod;
    amphipod.previousPosisitions.removeLast();
    if (isLocking) {
      assert(amphipod.locked);
      amphipod.locked = false;
    }
    amphipod.x = fromX;
    amphipod.y = fromY;
    cell.occupant = null;
    board.movedAmphipods.removeLast();
    board.moves.removeLast();
    // print('<-----');
  }
}

bool firstPring = true;
void printBoard(Board board) {
  final builder = StringBuffer('\n');
  for (final row in board.cells) {
    for (final cell in row) {
      builder.write(cell == null ? ' ' : cell.occupant?.name ?? '.');
    }
    builder.writeln();
  }
  builder.toString();
  print(builder);
}

class Point {
  Point(this.x, this.y);
  final int x, y;
}

class Amphipod {
  Amphipod({
    required this.name,
    required this.cost,
    required this.x,
    required this.y,
    required this.correctRoom,
  });

  @override
  String toString() => '$name($consumedEnergy) at $x,$y';

  int x, y;
  int consumedEnergy = 0;
  bool locked = false;
  final previousPosisitions = Queue<Point>();
  final bannedMoves = <Move>[];
  int minRequiredCost = 0;

  final int cost;
  final String name;
  final int correctRoom;

  Point? canMoveToCorrectRoom(Board board) {
    final bottomCorrectRoom = board.cells[2][correctRoom]!;
    if (correctRoom == this.x &&
        (y == 2 ||
            y == 1 &&
                bottomCorrectRoom.isOccupied &&
                bottomCorrectRoom.occupant!.correctRoom == correctRoom)) {
      // already there
      return null;
    }
    if (bottomCorrectRoom.isOccupied &&
        bottomCorrectRoom.occupant!.correctRoom != correctRoom) {
      return null;
    }
    final topCorrectRoom = board.cells[1][correctRoom]!;
    if (topCorrectRoom.isOccupied) {
      return null;
    }
    if (y == 2 && board.cells[0][1]!.isOccupied) {
      return null;
    }
    if (y >= 1 && board.cells[0][0]!.isOccupied) {
      return null;
    }
    final dx = (correctRoom - this.x).sign;
    int x = this.x;
    do {
      x += dx;
      if (board.cells[0][x]!.isOccupied) {
        return null;
      }
    } while (x != correctRoom);
    return Point(correctRoom, bottomCorrectRoom.isOccupied ? 1 : 2);
  }

  List<Move> reachableMoves(Board board) {
    final moves = <Move>[];
    if (locked) {
      final target = canMoveToCorrectRoom(board);
      if (target != null) {
        assert(target.x == correctRoom);
        assert(target.y > 0);
        assert(y == 0);
        final dx = (correctRoom - x).abs();
        final dy = (target.y - y);
        assert(dy > 0);
        final move = Move(this.x, this.y, target.x, target.y);
        move.cost = dx * cost + dy * cost;
        move.isLocking = false;
        moves.add(move);
        // print(
        // 'Move of ${cost} (${name}) ${move} ($dx, $dy) costs ${move.cost}');
      }
    } else {
      final target = canMoveToCorrectRoom(board);
      if (target != null) {
        assert(target.x == correctRoom);
        assert(target.y > 0);
        final dx = (correctRoom - x).abs();
        final dy = (target.y + y);
        assert(dy > 0);
        final move = Move(this.x, this.y, target.x, target.y);
        move.cost = dx * cost + dy * cost;
        move.isLocking = false;
        moves.add(move);
        // print(
        // 'Move of ${cost} (${name}) ${move} ($dx, $dy) costs ${move.cost}');
        // exit(0);
      } else if (y != 2 || x != correctRoom) {
        if ((y == 1 || board.cells[1][x]!.isNotOccupied) &&
            board.cells[0][correctRoom]!.isNotOccupied) {
          var moveCost = y * cost;
          for (int tx = x + 1; tx < 11; tx++) {
            moveCost += cost;
            if (board.cells[0][tx]!.isOccupied) {
              break;
            }
            if (tx.isOdd || tx == 0 || tx == 10)
              moves.add(
                Move(x, y, tx, 0)
                  ..cost = moveCost
                  ..isLocking = true,
              );
          }
          moveCost = y * cost;
          for (int tx = x - 1; tx >= 0; tx--) {
            moveCost += cost;
            if (board.cells[0][tx]!.isOccupied) {
              break;
            }
            if (tx.isOdd || tx == 0 || tx == 10)
              moves.add(
                Move(x, y, tx, 0)
                  ..cost = moveCost
                  ..isLocking = true,
              );
          }
        }
      }
    }

    // print('');
    // print(this);
    // print(''.padLeft(10, '-'));
    // print(moves);
    // print(''.padLeft(10, '-'));
    return moves;
  }

  List<Move> possibleMoves(Board board) => [
        if (locked) ...[
          if (canMoveToCorrectRoom(board) != null)
            Move(x, y, (correctRoom - x).sign, x == correctRoom ? y + 1 : y)
        ] else if (y == 0) ...[
          if (previousPosisitions.last.y != 1 &&
              x == correctRoom &&
              board.cells[1][x]!.isNotOccupied &&
              (board.cells[2][x]!.isNotOccupied ||
                  board.cells[2][2]!.occupant!.correctRoom == x))
            Move(x, y, x, 1),
          if (x > 0 &&
              // !(name == 'C' && x < 6) &&
              // !(name == 'D' && x < 6) &&
              board.cells[0][x - 1]!.isNotOccupied &&
              !(previousPosisitions.last.x == x - 1 &&
                  x - 1 == board.moves.last.fromX &&
                  previousPosisitions.last.y == 0 &&
                  0 == board.moves.last.fromY) &&
              previousPosisitions
                      .where((p) => p.x == x - 1 && p.y == 0)
                      .length <
                  2)
            Move(x, y, x - 1, y),
          if (x < 10 &&
              // !(name == 'A' && x > 4) &&
              // !(name == 'B' && x > 4) &&
              board.cells[0][x + 1]!.isNotOccupied &&
              !(previousPosisitions.last.x == x + 1 &&
                  x + 1 == board.moves.last.fromX &&
                  previousPosisitions.last.y == 0 &&
                  0 == board.moves.last.fromY) &&
              previousPosisitions
                      .where((p) => p.x == x + 1 && p.y == 0)
                      .length <
                  2)
            Move(x, y, x + 1, y),
        ] else if (y == 1) ...[
          if (x == correctRoom && board.cells[2][x]!.isNotOccupied)
            Move(x, y, x, 2),
          if ((x != correctRoom ||
                  (board.cells[2][x]!.isOccupied &&
                      board.cells[2][x]!.occupant!.correctRoom != x)) &&
              board.cells[0][x]!.isNotOccupied)
            Move(x, y, x, 0),
        ] else if (x != correctRoom && board.cells[1][x]!.isNotOccupied)
          Move(x, y, x, 1),
      ]..removeWhere(bannedMoves.contains);

  bool get canStop => (y == 2) || x.isOdd || x == 0 || x == 10;

  bool get isInCorrectRoom => x == correctRoom && y > 0;
  bool canMove(Board board) {
    if (x > 0 &&
        board.cells[y][x - 1] != null &&
        board.cells[y][x - 1]!.occupant == null) {
      return true;
    }
    if (x < 10 &&
        board.cells[y][x + 1] != null &&
        board.cells[y][x + 1]!.occupant == null) {
      return true;
    }
    if (y > 0 &&
        board.cells[y - 1][x] != null &&
        board.cells[y - 1][x]!.occupant == null) {
      return true;
    }
    if (y < 2 &&
        board.cells[y + 1][x] != null &&
        board.cells[y + 1][x]!.occupant == null) {
      return true;
    }
    return false;
  }
}

class MoveToExplore {
  MoveToExplore(this.step, this.move, this.minRequiredCost);
  final int step;
  final Move move;
  final int minRequiredCost;

  void perform(Board board) => move.perform(board);
  void undo(Board board) => move.undo(board);
}

final part1 = Part(
  parser: (lines) => Board([
    [for (final _ in range(11)) '.'],
    [for (final i in range(1, 12)) lines[2][i]],
    ['#', for (final i in range(2, 11)) lines[3][i], '#'],
  ]),
  implementation: (board) async {
    final amphipods = Queue.of(board.cells
        .flatten()
        .where((c) => c != null && c.isOccupied)
        .map((c) => c!.occupant!)
        .toList()
      ..sort((lhs, rhs) => lhs.y.compareTo(rhs.y)));
    var minCost = maxInt64;
    final movesToExplore = Queue.of([
      for (final amphipod in amphipods)
        ...amphipod
            .reachableMoves(board)
            .map((m) => MoveToExplore(1, m, board.minRequiredCost)),
    ]);
    int lastStep = 0;
    while (movesToExplore.isNotEmpty) {
      // print(movesToExplore.map((m) => m.move));
      // print(movesToExplore.length);
      final move = movesToExplore.removeLast();
      // print(move.step);
      if (move.step <= lastStep) {
        assert(board.moves.length == lastStep,
            '${move.step} ${board.moves.length} $lastStep');
        while (board.moves.length >= move.step) {
          board.moves.last.undo(board);
        }
      }
      if (board.cost + board.minRequiredCost >= minCost) {
        while (board.cost + board.minRequiredCost >= minCost) {
          board.moves.last.undo(board);
        }
        while (movesToExplore.isNotEmpty &&
            movesToExplore.last.step > board.moves.length) {
          movesToExplore.removeLast();
        }
        lastStep = board.moves.length;
        movesToExplore.removeWhere((m) => m.minRequiredCost >= minCost);
        continue;
      }
      // final amphipod = board.cells[move.move.fromY][move.move.fromX]!.occupant!;
      assert(board.moves.length + 1 == move.step,
          '$lastStep ${board.moves.length} ${move.step}');
      move.perform(board);
      // printBoard(board);
      lastStep = move.step;
      if (board.isFinished) {
        // print('Finished at step ${move.step}!');
        if (board.cost < minCost) {
          minCost = board.cost;
          print('New minCost $minCost');
        }
        // move.undo(board);
        // await Future<void>.delayed(const Duration(milliseconds: 1000));
        continue;
      }
      final possibleMoves = amphipods
          .map((a) => a.reachableMoves(board))
          .flatten()
          .map((m) => MoveToExplore(
              move.step + 1, m, board.minRequiredCost + (m.cost ?? 0)))
          .where((m) => m.minRequiredCost < minCost)
          .toList();
      final correctMove = possibleMoves.firstWhereOrNull((m) => m.move.toY > 0);
      if (correctMove != null) {
        // print('Correct move: ${correctMove.move}');
        movesToExplore.add(correctMove);
      } else {
        movesToExplore.addAll(possibleMoves
            .where((m) => !movesToExplore.any((o) => o.move == m)));
      }
      if (movesToExplore.isNotEmpty) {
        final next = movesToExplore.last;
        // print(next.move);
        if (next.step != lastStep + 1) {
          // print('Undoing...');
        } else {
          final nextAmphipod =
              board.cells[next.move.fromY][next.move.fromX]!.occupant!;
          // print(
          // 'Next move: $nextAmphipod -> ${next.move.toX},${next.move.toY}');
        }
      }
      // await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return minCost.toString();
  },
);

final part2 = Part(
  parser: parseInts,
  implementation: (input) {
    int last = input[0] + input[1] + input[2];
    int increases = 0;

    for (int i = 0; i < input.length - 2; i++) {
      final sum = input[i] + input[i + 1] + input[i + 2];
      if (sum > last) {
        increases += 1;
      }
      last = sum;
    }
    return '$increases increases';
  },
);
