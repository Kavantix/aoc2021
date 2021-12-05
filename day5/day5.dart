import 'dart:math';

import '../common.dart';

class Line {
  Line({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
  });
  final int startX, startY;
  final int endX, endY;

  bool get isHorizontal => startY == endY;
  bool get isVertical => startX == endX;
  bool get isDiagonal => startX != endX && startY != endY;

  static Line fromString(String input) {
    final parts = input.split(' -> ');
    final start = parts[0].split(',').map(int.parse).toList();
    final end = parts[1].split(',').map(int.parse).toList();
    return Line(
      startX: start[0],
      startY: start[1],
      endX: end[0],
      endY: end[1],
    );
  }
}

List<Line> parseLines(List<String> input) {
  return input.map(Line.fromString).toList();
}

final part1 = Part(
  parser: parseLines,
  implementation: (lines) {
    final board = List.generate(1000, (_) => List.filled(1000, 0));
    for (final line in lines) {
      if (line.isHorizontal) {
        for (int x = min(line.startX, line.endX);
            x <= max(line.startX, line.endX);
            x++) {
          board[line.startY][x] += 1;
        }
      } else if (line.isVertical) {
        for (int y = min(line.startY, line.endY);
            y <= max(line.startY, line.endY);
            y++) {
          board[y][line.startX] += 1;
        }
      }
    }
    final overlaps = board.expand((l) => l).where((c) => c > 1).length;
    return overlaps.toString();
  },
);

final part2 = Part(
  parser: parseLines,
  implementation: (lines) {
    final board = List.generate(1000, (_) => List.filled(1000, 0));
    for (final line in lines) {
      if (line.isHorizontal) {
        for (int x = min(line.startX, line.endX);
            x <= max(line.startX, line.endX);
            x++) {
          board[line.startY][x] += 1;
        }
      } else if (line.isVertical) {
        for (int y = min(line.startY, line.endY);
            y <= max(line.startY, line.endY);
            y++) {
          board[y][line.startX] += 1;
        }
      } else if (line.isDiagonal) {
        int x = line.startX;
        int y = line.startY;
        final dx = line.endX - line.startX > 0 ? 1 : -1;
        final dy = line.endY - line.startY > 0 ? 1 : -1;
        while (x != line.endX + dx || y != line.endY + dy) {
          board[y][x] += 1;
          x += dx;
          y += dy;
        }
      }
    }
    final overlaps = board.expand((l) => l).where((c) => c > 1).length;
    return overlaps.toString();
  },
);
