import 'dart:math';

import '../common.dart';

class Input {
  Input({
    required this.instructions,
    required this.image,
  });

  final List<int> instructions;
  final List<List<int>> image;

  factory Input.fromLines(List<String> lines) {
    assert(lines.first.length == 512);
    assert(lines[1].isEmpty);
    final mapping = (String c) {
      switch (c) {
        case '#':
          return 1;
        case '.':
          return 0;
      }
      throw FallThroughError();
    };

    final imageWidth = lines[2].length;
    const padding = 104;

    return Input(
      instructions: lines.first.split('').map(mapping).toList(),
      image: [
        for (final _ in range(padding ~/ 2))
          [for (final _ in range(imageWidth + padding)) 0],
        for (final line in lines.skip(2))
          [
            for (final _ in range(padding ~/ 2)) 0,
            ...line.split('').map(mapping),
            for (final _ in range(padding ~/ 2)) 0,
          ],
        for (final _ in range(padding ~/ 2))
          [for (final _ in range(imageWidth + padding)) 0],
      ],
    );
  }
}

int numberForKernel(Iterable<Iterable<int>> kernel) {
  final numbers = kernel.flatten().iterator;
  int result = 0;
  result += (numbers..moveNext()).current << 8;
  result += (numbers..moveNext()).current << 7;
  result += (numbers..moveNext()).current << 6;
  result += (numbers..moveNext()).current << 5;
  result += (numbers..moveNext()).current << 4;
  result += (numbers..moveNext()).current << 3;
  result += (numbers..moveNext()).current << 2;
  result += (numbers..moveNext()).current << 1;
  result += (numbers..moveNext()).current;
  return result;
}

void printImage(Iterable<Iterable<int>> image) {
  for (final line in image) {
    var output = '';
    for (final column in line) {
      output += column > 0 ? '██' : '  ';
    }
    print(output);
  }
}

final part1 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    var image = input.image;
    final imageWidth = image.first.length;
    final imageHeight = image.length;
    // printImage(image);

    int infinitePixel = 0;
    for (final _ in range(2)) {
      infinitePixel = input.instructions[infinitePixel * 511];
      image = [
        [for (final _ in range(imageWidth)) infinitePixel],
        for (final y in range(1, imageHeight - 1))
          [
            infinitePixel,
            ...[
              for (final x in range(1, imageWidth - 1))
                input.instructions[numberForKernel(
                  image
                      .skip(y - 1)
                      .take(3)
                      .map((line) => line.skip(x - 1).take(3)),
                )],
            ],
            infinitePixel,
          ],
        [for (final _ in range(imageWidth)) infinitePixel],
      ];
      ;
      // printImage(image);
    }

    return image.flatten().sum().toString();
  },
);

final part2 = Part(
  parser: Input.fromLines,
  implementation: (input) {
    var image = input.image;
    final imageWidth = image.first.length;
    final imageHeight = image.length;
    // printImage(image);

    int infinitePixel = 0;
    for (final _ in range(50)) {
      infinitePixel = input.instructions[infinitePixel * 511];
      image = [
        [for (final _ in range(imageWidth)) infinitePixel],
        for (final y in range(1, imageHeight - 1))
          [
            infinitePixel,
            ...[
              for (final x in range(1, imageWidth - 1))
                input.instructions[numberForKernel(
                  image
                      .skip(y - 1)
                      .take(3)
                      .map((line) => line.skip(x - 1).take(3)),
                )],
            ],
            infinitePixel,
          ],
        [for (final _ in range(imageWidth)) infinitePixel],
      ];
    }
    // printImage(image);
    return image.flatten().sum().toString();
  },
);
