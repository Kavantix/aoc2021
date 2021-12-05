import '../common.dart';

class Point {
  const Point(this.x, this.y);
  final int x, y;

  static Point fromString(String input) {
    final parts = input.split(',').map(int.parse).toList();
    return Point(parts[0], parts[1]);
  }
}

class LineIterator extends Iterator<Point> {
  LineIterator(this.line)
      : _dx = line.to.x.compareTo(line.from.x),
        _dy = line.to.y.compareTo(line.from.y);

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
      _current = line.from;
      return true;
    }
    if (current.x == line.to.x && current.y == line.to.y) {
      return false;
    }
    _current = Point(current.x + _dx, current.y + _dy);
    return true;
  }
}

class Line extends Iterable<Point> {
  Line({required this.from, required this.to});
  final Point from, to;

  bool get isHorizontal => from.y == to.y;
  bool get isVertical => from.x == to.x;
  bool get isDiagonal => !isHorizontal && !isVertical;

  static Line fromString(String input) {
    final parts = input.split(' -> ');
    return Line(
      from: Point.fromString(parts[0]),
      to: Point.fromString(parts[1]),
    );
  }

  @override
  LineIterator get iterator => LineIterator(this);
}

Part<Iterable<Line>> partWhere(bool Function(Line line) test) => Part(
      parser: (input) => input.map(Line.fromString).where(test),
      implementation: (lines) {
        final board = List.generate(1000, (_) => List.filled(1000, 0));
        for (final line in lines) {
          for (final point in line) {
            board[point.y][point.x] += 1;
          }
        }
        return board.expand((l) => l).where((c) => c > 1).length.toString();
      },
    );

final part1 = partWhere((l) => l.isHorizontal || l.isVertical);
final part2 = partWhere((l) => l.isHorizontal || l.isVertical || l.isDiagonal);
