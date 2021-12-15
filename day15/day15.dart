import 'dart:collection';
import 'dart:math';

import '../common.dart';

class Point {
  Point(this.x, this.y);

  final int x, y;
}

final part1 = Part(
  parser: (lines) => lines.map((l) => parseInts(l.split(''))).toList(),
  implementation: (input) {
    input[0][0] = 0;
    final costToReach =
        List.generate(input.length, (_) => List.filled(input.first.length, 0));
    final queued = List.generate(
        input.length, (_) => List.filled(input.first.length, false));
    costToReach[input.length - 1][input.first.length - 1] = input.last.last;
    queued[input.length - 1][input.first.length - 1] = true;
    final toExplore = Queue.of([
      Point(input.first.length - 1, input.length - 2),
      Point(input.first.length - 2, input.length - 1),
    ]);
    queued[input.length - 2][input.first.length - 1] = true;
    queued[input.length - 1][input.first.length - 2] = true;
    while (toExplore.isNotEmpty) {
      final point = toExplore.removeFirst();
      final risk = input[point.y][point.x];
      int cost = maxInt64;
      if (point.y < input.length - 1) {
        cost = min(cost, risk + costToReach[point.y + 1][point.x]);
      }
      if (point.x < input.first.length - 1) {
        cost = min(cost, risk + costToReach[point.y][point.x + 1]);
      }
      costToReach[point.y][point.x] = cost;
      if (point.x > 0 && !queued[point.y][point.x - 1]) {
        queued[point.y][point.x - 1] = true;
        toExplore.add(Point(point.x - 1, point.y));
      }
      if (point.y > 0 && !queued[point.y - 1][point.x]) {
        queued[point.y - 1][point.x] = true;
        toExplore.add(Point(point.x, point.y - 1));
      }
    }
    for (final row in input) {
      print(row.map((c) => c.toString().padLeft(3)));
    }
    print('');
    for (final row in costToReach) {
      print(row.map((c) => c.toString().padLeft(3)));
    }
    return costToReach[0][0].toString();
  },
);

final part2 = Part(
  parser: (lines) => lines.map((l) => parseInts(l.split(''))).toList(),
  implementation: (input) {
    for (final row in input) {
      final rowLength = row.length;
      for (final x in range(4)) {
        row.addAll(row
            .skip(x * rowLength)
            .map(increment)
            .map((i) => i == 10 ? 1 : i)
            .toList());
      }
    }
    final originalInputLength = input.length;
    for (final y in range(4)) {
      input.addAll(input
          .skip(y * originalInputLength)
          .map((row) => row.map(increment).map((i) => i == 10 ? 1 : i).toList())
          .toList());
    }
    input[0][0] = 0;
    final costToReach =
        List.generate(input.length, (_) => List.filled(input.first.length, 0));
    final queued = List.generate(
        input.length, (_) => List.filled(input.first.length, false));
    costToReach[input.length - 1][input.first.length - 1] = input.last.last;
    queued[input.length - 1][input.first.length - 1] = true;
    final toExplore = Queue.of([
      Point(input.first.length - 1, input.length - 2),
      Point(input.first.length - 2, input.length - 1),
    ]);
    queued[input.length - 2][input.first.length - 1] = true;
    queued[input.length - 1][input.first.length - 2] = true;
    while (toExplore.isNotEmpty) {
      final point = toExplore.removeFirst();
      final risk = input[point.y][point.x];
      int cost = maxInt64;
      if (point.y < input.length - 1) {
        cost = min(cost, risk + costToReach[point.y + 1][point.x]);
      }
      if (point.x < input.first.length - 1) {
        cost = min(cost, risk + costToReach[point.y][point.x + 1]);
      }
      costToReach[point.y][point.x] = cost;
      if (point.x > 0 && !queued[point.y][point.x - 1]) {
        queued[point.y][point.x - 1] = true;
        toExplore.add(Point(point.x - 1, point.y));
      }
      if (point.y > 0 && !queued[point.y - 1][point.x]) {
        queued[point.y - 1][point.x] = true;
        toExplore.add(Point(point.x, point.y - 1));
      }
    }
    for (final row in input) {
      print(row.map((c) => c.toString().padLeft(3)));
    }
    print('');
    for (final row in costToReach) {
      print(row.map((c) => c.toString().padLeft(3)));
    }
    return costToReach[0][0].toString();
  },
);
