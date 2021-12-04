import '../common.dart';

final part1 = Part(
  parser: parseInts,
  implementation: (input) {
    int last = input[0];
    int increases = 0;

    for (final number in input) {
      if (number > last) {
        increases += 1;
      }
      last = number;
    }
    return '$increases increases';
  },
);

final part2 = Part(
  parser: parseInts,
  implementation: (input) {
    int last = input[0] + input[1] + input[2];
    int increases = 0;

    for (int i = 0; i < input.length - 2; i++) {
      final sum = input[i] + input[i + 1] + input[i + 2];
      if (sum > last) {
        increases += 1;
      }
      last = sum;
    }
    return '$increases increases';
  },
);
