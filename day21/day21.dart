import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import '../common.dart';

final part1 = Part(
  parser: (lines) =>
      lines.map((l) => int.parse(l.split(' ').last) - 1).toList(),
  implementation: (input) {
    var player1 = input[0];
    var player1Score = 0;
    var player2 = input[1];
    var player2Score = 0;
    var die = 0;
    var dieRolls = 0;
    while (player2Score < 1000) {
      var steps = (die + 1) % 100 + (die + 2) % 100 + (die + 3) % 100;
      print(steps);
      die = (die + 3) % 100;
      dieRolls += 3;
      player1 = (player1 + steps) % 10;
      player1Score += player1 + 1;
      if (player1Score >= 1000) break;
      steps = (die + 1) % 100 + (die + 2) % 100 + (die + 3) % 100;
      print(steps);
      die = (die + 3) % 100;
      dieRolls += 3;
      player2 = (player2 + steps) % 10;
      player2Score += player2 + 1;
    }
    print('''
die:      $die
dieRolls: $dieRolls
player1:  $player1 ($player1Score)
player2:  $player2 ($player2Score)
        ''');
    return (dieRolls * min(player1Score, player2Score)).toString();
  },
);

final dieCounts = () {
  final dies = [
    for (final k in range(1, 4))
      for (final i in range(1, 4))
        for (final j in range(1, 4)) i + j + k,
  ];
  return [
    for (final i in range(10)) dies.where((d) => d == i).length,
  ];
}();

class Version {
  Version(
    this.score1,
    this.position1,
    this.score2,
    this.position2,
    this.universes,
  );
  final int score1;
  final int position1;
  final int score2;
  final int position2;
  int universes;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      position1 + (score1 << 8) + (score2 << 16) + (position2 << 24);

  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(covariant Version other) =>
      other.position2 == position2 &&
      other.position1 == position1 &&
      other.score2 == score2 &&
      other.score1 == score1;
}

final part2 = Part(
  parser: (lines) =>
      lines.map((l) => int.parse(l.split(' ').last) - 1).toList(),
  implementation: (input) {
    final versionsToExplore = HashSet<Version>()
      ..add(
        Version(0, input[0], 0, input[1], 1),
      );
    int universes1 = 0;
    int universes2 = 0;
    int iterations = 0;
    print(dieCounts);
    // final memo = <int, int>{};
    while (versionsToExplore.isNotEmpty) {
      final version = versionsToExplore.first;
      versionsToExplore.remove(version);
      // memo.update(
      //   version.position1 +
      //       (version.score1 << 8) +
      //       (version.score2 << 16) +
      //       (version.position2 << 24),
      //   increment,
      //   ifAbsent: () => 1,
      // );
      for (int die1 = 3; die1 <= 9; die1++) {
        final universes = version.universes * dieCounts[die1];
        final position1 = (version.position1 + die1) % 10;
        final score1 = version.score1 + position1 + 1;
        if (score1 < 21) {
          for (int die2 = 3; die2 <= 9; die2++) {
            final position2 = (version.position2 + die2) % 10;
            final score2 = version.score2 + position2 + 1;
            iterations += 1;
            if (score2 < 21) {
              final newVersion = Version(
                score1,
                position1,
                score2,
                position2,
                universes * dieCounts[die2],
              );
              if (versionsToExplore.contains(newVersion)) {
                final other = versionsToExplore.lookup(newVersion)!;
                other.universes += newVersion.universes;
                // assert(other.universes == newVersion.universes);
              } else {
                versionsToExplore.add(newVersion);
              }
            } else {
              universes2 += universes * dieCounts[die2];
            }
          }
        } else {
          iterations += 1;
          universes1 += universes;
        }
      }
    }
    print('''
iterations: $iterations
universes1: $universes1
universes2: $universes2
        ''');
    return max(universes1, universes2).toString();
  },
);
