import 'dart:math';

import '../common.dart';

class Input {
  Input(this.startX, this.startY, this.endX, this.endY);

  final int startX, startY;
  final int endX, endY;

  factory Input.fromLines(List<String> input) {
    final match = RegExp(r'target area: x=(\d+)\.\.(\d+), y=(-\d+)\.\.(-\d+)')
        .firstMatch(input.first)!;
    return Input(
      int.parse(match.group(1)!),
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(4)!),
    );
  }
}

final part1 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    int maxHeight = input.startY;
    for (final v in range(1000)) {
      int yPosition = 0;
      int maxY = 0;
      int yVelocity = v;
      while (yPosition > input.endY) {
        if (yPosition > maxY) {
          maxY = yPosition;
        }
        yPosition += yVelocity;
        yVelocity -= 1;
      }
      if (yPosition >= input.startY) {
        maxHeight = maxY;
        print('Initial yVelocity $v reached $maxY');
      }
    }

    return maxHeight.toString();
  },
);

final part2 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    const maxHeightYVelocity = 107; // Velocity from part 1
    final minPossibleXVelocity = (sqrt(input.endX * 2).floor()) - 1;
    assert(
        minPossibleXVelocity * (minPossibleXVelocity + 1) / 2 >= input.startY);
    int possibleVelocities = 0;
    for (final yVelocity in range(input.startY, maxHeightYVelocity + 1)) {
      for (final xVelocity in range(minPossibleXVelocity - 1, input.endX + 1)) {
        int x = 0;
        int dx = xVelocity;
        int y = 0;
        int dy = yVelocity;
        while (y >= input.startY) {
          if (x <= input.endX && x >= input.startX && y <= input.endY) {
            possibleVelocities += 1;
            break;
          }
          x += dx;
          dx += 0.compareTo(dx);
          y += dy;
          dy -= 1;
        }
      }
    }
    return possibleVelocities.toString();
  },
);
