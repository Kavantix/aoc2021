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
    final imageWidth = input.image.first.length;
    final imageHeight = input.image.length;
    var image = input.image;
    // printImage(image);

    int infinitePixel = 0;
    for (final _ in range(2)) {
      infinitePixel = input.instructions[infinitePixel * 511];
      final newImage =
          List.generate(imageWidth, (_) => List.filled(imageHeight, 0));
      for (final i in range(imageWidth)) {
        newImage[0][i] = infinitePixel;
        newImage[imageHeight - 1][i] = infinitePixel;
      }
      for (final i in range(imageHeight)) {
        newImage[i][0] = infinitePixel;
        newImage[i][imageWidth - 1] = infinitePixel;
      }
      for (final x in range(1, imageWidth - 1)) {
        int kernel =
            ((image[0][x - 1] << 2) + (image[0][x] << 1) + image[0][x + 1]) <<
                3;
        kernel += (image[1][x - 1] << 2) + (image[1][x] << 1) + image[1][x + 1];
        for (final y in range(1, imageHeight - 1)) {
          kernel = kernel << 3;
          kernel = (kernel +
                  (image[y + 1][x - 1] << 2) +
                  (image[y + 1][x] << 1) +
                  image[y + 1][x + 1]) &
              511;
          newImage[y][x] = input.instructions[kernel];
        }
      }
      image = newImage;
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
      final newImage =
          List.generate(imageWidth, (_) => List.filled(imageHeight, 0));
      for (final i in range(imageWidth)) {
        newImage[0][i] = infinitePixel;
        newImage[imageHeight - 1][i] = infinitePixel;
      }
      for (final i in range(imageHeight)) {
        newImage[i][0] = infinitePixel;
        newImage[i][imageWidth - 1] = infinitePixel;
      }
      for (final x in range(1, imageWidth - 1)) {
        int kernel =
            ((image[0][x - 1] << 2) + (image[0][x] << 1) + image[0][x + 1]) <<
                3;
        kernel += (image[1][x - 1] << 2) + (image[1][x] << 1) + image[1][x + 1];
        for (final y in range(1, imageHeight - 1)) {
          kernel = kernel << 3;
          kernel = (kernel +
                  (image[y + 1][x - 1] << 2) +
                  (image[y + 1][x] << 1) +
                  image[y + 1][x + 1]) &
              511;
          newImage[y][x] = input.instructions[kernel];
        }
      }
      image = newImage;
    }
    // printImage(image);
    return image.flatten().sum().toString();
  },
);
