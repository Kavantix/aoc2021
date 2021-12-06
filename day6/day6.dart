import '../common.dart';

List<int> parseFish(List<String> input) {
  final timers = input.first.split(',').map(int.parse).toList();
  timers.sort();
  final groups = List.filled(9, 0);
  for (final timer in timers) {
    groups[timer] += 1;
  }
  return groups;
}

Part<List<int>> partForIterations(int iterations) {
  return Part(
    parser: parseFish,
    implementation: (fish) {
      for (int i = 0; i < iterations; i++) {
        final int offspring = fish.first;
        fish = [
          for (int i = 0; i < 6; i++) fish[i + 1],
          fish[7] + fish[0],
          fish[8],
          offspring,
        ];
      }
      return '${fish.sum()} fish';
    },
  );
}

final part1 = partForIterations(80);
final part2 = partForIterations(256);
