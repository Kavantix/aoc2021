import 'dart:math';

import '../common.dart';

final rotations = <Point Function(Point)>[
  // y+ is up
  (p) => Point(p.x, p.y, p.z), // x+
  (p) => Point(-p.x, p.y, -p.z), //x-
  // y- is up
  (p) => Point(p.x, -p.y, -p.z), // x+
  (p) => Point(-p.x, -p.y, p.z), //x-
  // z+ is up
  (p) => Point(p.x, p.z, -p.y), // x+
  (p) => Point(-p.x, p.z, p.y), //x-
  // z- is up
  (p) => Point(p.x, -p.z, p.y), // x+
  (p) => Point(-p.x, -p.z, -p.y), //x-

  // z+ is up
  (p) => Point(p.y, p.z, p.x), //y+
  (p) => Point(-p.y, p.z, -p.x), //y-
  // z- is up
  (p) => Point(p.y, -p.z, -p.x), //y+
  (p) => Point(-p.y, -p.z, p.x), //y-
  // x+ is up
  (p) => Point(p.y, p.x, -p.z), //y+
  (p) => Point(-p.y, p.x, p.z), //y-
  // x- is up
  (p) => Point(p.y, -p.x, p.z), //y+
  (p) => Point(-p.y, -p.x, -p.z), //y-

  // y+ is up
  (p) => Point(p.z, p.y, -p.x), //z+
  (p) => Point(-p.z, p.y, p.x), //z-
  // y- is up
  (p) => Point(p.z, -p.y, p.x), //z+
  (p) => Point(-p.z, -p.y, -p.x), //z-
  // x+ is up
  (p) => Point(p.z, p.x, p.y), //z+
  (p) => Point(-p.z, p.x, -p.y), //z-
  // x- is up
  (p) => Point(p.z, -p.x, -p.y), //z+
  (p) => Point(-p.z, -p.x, p.y), //z-
];

class Point {
  const Point(this.x, this.y, this.z);

  final int x, y, z;

  factory Point.fromString(String input) {
    final coords = input.split(',').map(int.parse).toList();
    return Point(
      coords[0],
      coords[1],
      coords[2],
    );
  }

  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y && other.z == z;

  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => x + (y << 16) + (z << 32);

  Point operator +(Point other) => Point(
        x + other.x,
        y + other.y,
        z + other.z,
      );

  Point operator -(Point other) => Point(
        x - other.x,
        y - other.y,
        z - other.z,
      );

  int sum() => x + y + z;
  int absSum() => x.abs() + y.abs() + z.abs();

  @override
  String toString() => '$x, $y, $z';
}

int dotProductLength(Point p) => p.x * p.x + p.y * p.y + p.z * p.z;

int iterations = 0;

class Scanner {
  Scanner({
    required this.name,
    required this.points,
  });

  final String name;
  final List<Point> points;
  Point? offsetToScanner0;
  Point Function(Point)? rotationToScanner0;

  late final distances = {
    for (final i in range(points.length))
      for (final j in range(points.length))
        if (i != j) dotProductLength(points[j] - points[i]),
  };

  factory Scanner.fromLines(Iterable<String> lines) {
    return Scanner(
      name: lines.first,
      points: lines.skip(1).map(Point.fromString).toList(),
    );
  }

  bool overlappingPointsWith(Scanner other) {
    if (distances.intersection(other.distances).length < 12) return false;
    for (final rotation in rotations) {
      final diffCounts = <Point, int>{};
      for (final otherPoint in other.points.map(rotation)) {
        for (final point in points) {
          final diff = point - otherPoint;
          if (diffCounts.update(diff, increment, ifAbsent: () => 1) >= 3) {
            other.offsetToScanner0 = rotationToScanner0!(diff);
            other.rotationToScanner0 = rotation;
            return true;
          }
        }
      }
    }
    return false;
  }
}

final part1 = Part(
  parser: (lines) {
    int offset = 0;
    final scanners = <Scanner>[];
    while (offset < lines.length - 10) {
      scanners.add(Scanner.fromLines(
        lines.skip(offset).takeWhile((l) => l.isNotEmpty),
      ));
      offset += scanners.last.points.length + 2;
    }
    return scanners;
  },
  implementation: (input) {
    final points = <Point>{}..addAll(input[0].points);
    input[0].offsetToScanner0 = const Point(0, 0, 0);
    input[0].rotationToScanner0 = (p) => p;
    final matchedScanners = [input[0]];
    final scannersToExplore = input.skip(1).toList();
    for (int j = 0; j < matchedScanners.length; j++) {
      final comparisonScanner = matchedScanners[j];
      for (int i = scannersToExplore.length - 1;
          i >= 0 && scannersToExplore.isNotEmpty;
          i--) {
        final scanner = scannersToExplore[i];
        final matches = comparisonScanner.overlappingPointsWith(scanner);
        if (matches) {
          assert(comparisonScanner.offsetToScanner0 != null);
          assert(scanner.offsetToScanner0 != null);
          scanner.offsetToScanner0 =
              comparisonScanner.offsetToScanner0! + scanner.offsetToScanner0!;
          final rotation = scanner.rotationToScanner0!;
          scanner.rotationToScanner0 =
              (p) => comparisonScanner.rotationToScanner0!(rotation(p));
          scannersToExplore.removeAt(i);
          matchedScanners.add(scanner);
          points.addAll(scanner.points.map((p) =>
              scanner.rotationToScanner0!(p) + scanner.offsetToScanner0!));
        }
      }
    }
    int maxDistance = 0;
    for (final i in range(input.length - 1)) {
      for (final j in range(i + 1, input.length)) {
        final diff = input[j].offsetToScanner0! - input[i].offsetToScanner0!;
        final distance = diff.absSum();
        maxDistance = max(maxDistance, distance);
      }
    }
    return '\n\tPart1: ${points.length}'
        '\n\tPart2: $maxDistance';
  },
);

final part2 = Part(parser: (l) => null, implementation: (_) => 'See part 1');
