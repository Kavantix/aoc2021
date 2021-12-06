import '../common.dart';

class Fish {
  Fish(this.timer);

  int timer;

  Fish? tick() {
    if (timer == 0) {
      timer = 6;
      return Fish(8);
    } else {
      timer -= 1;
    }
  }
}

List<Fish> parseFish(List<String> input) {
  return input.first.split(',').map((t) => Fish(int.parse(t))).toList();
}

final part1 = Part(
  parser: parseFish,
  implementation: (fish) {
    for (int i = 0; i < 256; i++) {
      final newFish = <Fish>[];
      for (final f in fish) {
        final n = f.tick();
        if (n != null) newFish.add(n);
      }
      fish.addAll(newFish);
    }
    return '${fish.length} fish';
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
