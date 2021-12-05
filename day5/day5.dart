import 'dart:math';

import '../common.dart';

class Point {
  const Point(this.x, this.y);
  final int x;
  final int y;

  @override
  String toString() {
    return '($x, $y)';
  }
}

class LineIterator extends Iterator<Point> {
  LineIterator(this.line)
      : _dx = line.end.x.compareTo(line.start.x),
        _dy = line.end.y.compareTo(line.start.y);

  final Line line;
  Point? _current;
  final int _dx;
  final int _dy;

  @override
  Point get current => _current!;

  @override
  bool moveNext() {
    final current = _current;
    if (current == null) {
      _current = line.start;
      return true;
    }
    if (current.x == line.end.x && current.y == line.end.y) {
      return false;
    }
    _current = Point(current.x + _dx, current.y + _dy);
    return true;
  }
}

class Line extends Iterable<Point> {
  Line({
    required this.start,
    required this.end,
  });
  final Point start;
  final Point end;

  bool get isHorizontal => start.y == end.y;
  bool get isVertical => start.x == end.x;
  bool get isDiagonal => start.x != end.x && start.y != end.y;

  static Line fromString(String input) {
    final parts = input.split(' -> ');
    final start = parts[0].split(',').map(int.parse).toList();
    final end = parts[1].split(',').map(int.parse).toList();
    return Line(
      start: Point(start[0], start[1]),
      end: Point(end[0], end[1]),
    );
  }

  @override
  LineIterator get iterator => LineIterator(this);

  @override
  String toString() {
    return '${start.x},${start.y} -> ${end.x},${end.y}';
  }
}

List<Line> parseLines(List<String> input) {
  return input.map(Line.fromString).toList();
}

final part1 = Part(
  parser: parseLines,
  implementation: (lines) {
    final board = List.generate(1000, (_) => List.filled(1000, 0));
    for (final line
        in lines.where((line) => line.isHorizontal || line.isVertical)) {
      for (final point in line) {
        board[point.y][point.x] += 1;
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
      for (final point in line) {
        board[point.y][point.x] += 1;
      }
    }
    final overlaps = board.expand((l) => l).where((c) => c > 1).length;
    return overlaps.toString();
  },
);
