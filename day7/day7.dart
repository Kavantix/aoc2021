import 'dart:math';

import '../common.dart';

final part1 = Part(
  parser: (lines) => lines.first.split(',').map(int.parse).toList(),
  implementation: (input) {
    input.sort();

    final median = input[input.length ~/ 2];
    final totalDistanceToMedian = input.map((e) => (e - median).abs()).sum();
    // Probably luck that this worked xD
    return 'median: $median, totalDistance: $totalDistanceToMedian';
  },
);

final part2 = Part(
  parser: (lines) => lines.first.split(',').map(int.parse).toList(),
  implementation: (input) {
    int cost(int n) => (n * (n + 1)) ~/ 2;

    final minimum = input.fold(1000000000, min);
    final maximum = input.fold(0, max);
    int minTotalDistance = 1000000000;
    int minP = -1;
    for (int p = minimum; p <= maximum; p++) {
      final totalDistance = input.map((e) => cost((e - p).abs())).sum();
      if (totalDistance < minTotalDistance) {
        minTotalDistance = totalDistance;
        minP = p;
      }
    }
    return 'postion: $minP, totalDistance: $minTotalDistance, min: $minimum, max: $maximum';
  },
);
