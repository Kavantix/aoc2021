import 'dart:collection';

import '../common.dart';

class Point {
  Point({
    required this.x,
    required this.y,
    required this.value,
  });
  final int x, y;
  int value;

  @override
  String toString() {
    return '($x,$y: $value)';
  }
}

bool samePoint(Point lhs, Point rhs) => lhs.x == rhs.x && lhs.y == rhs.y;

List<List<Point>> parseLines(List<String> lines) {
  return [
    for (int y = 0; y < lines.length; y++)
      [
        for (int x = 0; x < lines[y].length; x++)
          Point(
            x: x,
            y: y,
            value: int.parse(lines[y].substring(x, x + 1)),
          ),
      ],
  ];
}

bool pointInRange(int x, int y, List<List<Object>> points) {
  if (points.isEmpty) return false;
  return x >= 0 && y >= 0 && y < points.length && x < points.first.length;
}

const neighborsY = [-1, -1, -1, 0, 0, 1, 1, 1];
const neighborsX = [-1, 0, 1, -1, 1, -1, 0, 1];

final part1 = Part(
  parser: parseLines,
  implementation: (input) {
    int flashes = 0;
    for (final _ in range(100)) {
      final pointsToVisit = Queue.of(input.flatten());
      while (pointsToVisit.isNotEmpty) {
        final point = pointsToVisit.removeFirst();
        point.value += 1;
        if (point.value == 10) {
          flashes += 1;
          for (int i = 0; i < neighborsY.length; i++) {
            final y = neighborsY[i];
            final x = neighborsX[i];
            if (pointInRange(x + point.x, y + point.y, input)) {
              pointsToVisit.add(input[y + point.y][x + point.x]);
            }
          }
        }
      }
      for (final point in input.flatten()) {
        if (point.value >= 10) {
          point.value = 0;
        }
      }
    }
    printPoints(input);
    return flashes.toString();
  },
);

void printPoints(List<List<Point>> lines) {
  for (final line in lines) {
    var output = '';
    for (final point in line) {
      output += '${point.value}';
    }
    print(output);
  }
}

final part2 = Part(
  parser: parseLines,
  implementation: (input) {
    for (final i in range(1000)) {
      int flashes = 0;
      final pointsToVisit = Queue.of(input.flatten());
      while (pointsToVisit.isNotEmpty) {
        final point = pointsToVisit.removeFirst();
        point.value += 1;
        if (point.value == 10) {
          flashes += 1;
          for (int i = 0; i < neighborsY.length; i++) {
            final y = neighborsY[i];
            final x = neighborsX[i];
            if (pointInRange(x + point.x, y + point.y, input)) {
              pointsToVisit.add(input[y + point.y][x + point.x]);
            }
          }
        }
      }
      for (final point in input.flatten()) {
        if (point.value >= 10) {
          point.value = 0;
        }
      }
      if (flashes == input.length * input.first.length) {
        printPoints(input);
        return (i + 1).toString();
      }
    }
    throw FallThroughError();
  },
);
