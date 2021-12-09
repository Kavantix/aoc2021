import 'dart:collection';

import '../common.dart';

int addOne(int x) => x + 1;

final part1 = Part(
  parser: (lines) =>
      lines.map((line) => line.split('').map(int.parse).toList()).toList(),
  implementation: (input) {
    final lowPoints = <int>[];

    final width = input.first.length + 2;
    for (final line in input) {
      line.insert(0, 9);
      line.add(9);
    }
    input.insert(0, List.filled(width, 9));
    input.add(List.filled(width, 9));

    for (int y = 1; y < input.length - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final value = input[y][x];
        if (input[y][x - 1] > value &&
            input[y + 1][x] > value &&
            input[y][x + 1] > value &&
            input[y - 1][x] > value) {
          lowPoints.add(value);
        }
      }
    }

    print(lowPoints);
    return lowPoints.map(addOne).sum().toString();
  },
);

class Point {
  const Point({
    required this.x,
    required this.y,
    required this.value,
  });
  final int x, y;
  final int value;

  @override
  String toString() {
    return '($x,$y: $value)';
  }
}

bool samePoint(Point lhs, Point rhs) => lhs.x == rhs.x && lhs.y == rhs.y;

class Basin {
  Basin(this.lowPoint);

  final Point lowPoint;
  final points = <Point>[];

  @override
  String toString() {
    return '{$lowPoint: $points}';
  }
}

final part2 = Part(
  parser: (lines) =>
      lines.map((line) => line.split('').map(int.parse).toList()).toList(),
  implementation: (input) {
    final basins = <Basin>[];

    final width = input.first.length + 2;
    for (final line in input) {
      line.insert(0, 9);
      line.add(9);
    }
    input.insert(0, List.filled(width, 9));
    input.add(List.filled(width, 9));

    for (int y = 1; y < input.length - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        final value = input[y][x];
        if (input[y][x - 1] > value &&
            input[y + 1][x] > value &&
            input[y][x + 1] > value &&
            input[y - 1][x] > value) {
          basins.add(Basin(Point(x: x, y: y, value: value)));
        }
      }
    }

    for (final basin in basins) {
      final pointsToCheck = Queue.of([basin.lowPoint]);
      while (!pointsToCheck.isEmpty) {
        final point = pointsToCheck.removeFirst();
        if (point.value < 9 && !basin.points.any(samePoint.apply(point))) {
          basin.points.add(point);
        } else {
          continue;
        }
        final xs = [point.x - 1, point.x + 1, point.x, point.x];
        final ys = [point.y, point.y, point.y - 1, point.y + 1];
        for (int i = 0; i < 4; i++) {
          final x = xs[i];
          final y = ys[i];
          if (input[y][x] >= point.value) {
            pointsToCheck.add(Point(x: x, y: y, value: input[y][x]));
          }
        }
      }
    }

    basins.sort((l, r) => r.points.length.compareTo(l.points.length));

    for (final basin in basins.take(3)) {
      final minX = basin.points.map((p) => p.x).min();
      final maxX = basin.points.map((p) => p.x).max();
      final minY = basin.points.map((p) => p.y).min();
      final maxY = basin.points.map((p) => p.y).max();
      for (int y = minY; y <= maxY; y++) {
        var line = '';
        for (int x = minX; x <= maxX; x++) {
          if (basin.points.any(((p) => p.x == x && p.y == y))) {
            line += input[y][x].toString();
          } else {
            line += ' ';
          }
        }
        print(line);
      }
      print('');
    }
    return basins.take(3).map((b) => b.points.length).product().toString();
  },
);
