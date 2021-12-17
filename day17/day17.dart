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
    return 'TODO';
  },
);
