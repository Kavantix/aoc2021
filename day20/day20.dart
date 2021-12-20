import 'dart:typed_data';

import '../common.dart';

int mapping(String c) => c == '#' ? 1 : 0;

const imageSize = 204;

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
    assert(lines.length - 2 == lines[2].length);

    const imageWidth = imageSize;
    final padding = imageSize - lines[2].length;

    return Input(
      instructions:
          Uint8List.fromList(lines.first.split('').map(mapping).toList()),
      image: [
        for (int i = 0; i < padding ~/ 2; i++)
          List.generate(imageSize, (_) => 0),
        for (int l = 2; l < lines.length; l++)
          List.generate(imageSize, (x) {
            if (x < padding ~/ 2 || x >= imageWidth - padding ~/ 2) return 0;
            return mapping(lines[l][x - padding ~/ 2]);
          }),
        for (int i = 0; i < padding ~/ 2; i++)
          List.generate(imageSize, (_) => 0),
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
  implementation: (input) => imageAfter(2, input).flatten().sum().toString(),
);

final part2 = Part(
  parser: Input.fromLines,
  implementation: (input) => imageAfter(50, input).flatten().sum().toString(),
);

List<List<int>> imageAfter(int iterations, Input input) {
  var image = input.image;
  const imageWidth = imageSize;
  const imageHeight = imageSize;
  // printImage(image);

  {
    int infinitePixel = 0;
    var backImage =
        List.generate(imageHeight, (_) => List.generate(imageWidth, (_) => 0));
    for (final _ in range(iterations)) {
      infinitePixel = input.instructions[infinitePixel * 511];
      for (int y = 0; y < imageHeight; y++) {
        backImage[y][0] = infinitePixel;
        backImage[y][imageWidth - 1] = infinitePixel;
      }
      for (int x = 0; x < imageWidth; x++) {
        backImage[0][x] = infinitePixel;
        backImage[imageHeight - 1][x] = infinitePixel;
      }
      for (int x = 1; x < imageWidth - 1; x += 1) {
        int kernel =
            (((image[0][x - 1] << 2) + (image[0][x] << 1) + image[0][x + 1]) <<
                    3) +
                (image[1][x - 1] << 2) +
                (image[1][x] << 1) +
                image[1][x + 1];
        for (int y = 1; y < imageHeight - 1; y += 1) {
          kernel = ((kernel << 3) +
                  (image[y + 1][x - 1] << 2) +
                  (image[y + 1][x] << 1) +
                  image[y + 1][x + 1]) &
              511;
          backImage[y][x] = input.instructions[kernel];
        }
      }
      final temp = image;
      image = backImage;
      backImage = temp;
    }
  }
  return image;
}
