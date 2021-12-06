import '../common.dart';

class FishGroup {
  FishGroup({
    required this.timer,
    required this.count,
  });

  final int timer;
  final int count;
}

List<FishGroup> parseFish(List<String> input) {
  final timers = input.first.split(',').map(int.parse).toList();
  timers.sort();
  final groups = List.filled(9, 0);
  for (final timer in timers) {
    groups[timer] += 1;
  }
  return List.generate(
    groups.length,
    (i) => FishGroup(timer: i, count: groups[i]),
    growable: false,
  );
}

final part1 = Part(
  parser: parseFish,
  implementation: (fish) {
    for (int i = 0; i < 80; i++) {
      final int newFish = fish.first.count;
      fish = [
        for (int i = 0; i < 6; i++)
          FishGroup(timer: i, count: fish[i + 1].count),
        FishGroup(timer: 6, count: fish[7].count + fish[0].count),
        FishGroup(timer: 7, count: fish[8].count),
        FishGroup(timer: 8, count: newFish),
      ];
    }
    return '${fish.fold<int>(0, (acc, group) => acc + group.count)} fish';
  },
);

final part2 = Part(
  parser: parseFish,
  implementation: (fish) {
    for (int i = 0; i < 256; i++) {
      final int newFish = fish.first.count;
      fish = [
        for (int i = 0; i < 6; i++)
          FishGroup(timer: i, count: fish[i + 1].count),
        FishGroup(timer: 6, count: fish[7].count + fish[0].count),
        FishGroup(timer: 7, count: fish[8].count),
        FishGroup(timer: 8, count: newFish),
      ];
    }
    return '${fish.fold<int>(0, (acc, group) => acc + group.count)} fish';
  },
);
