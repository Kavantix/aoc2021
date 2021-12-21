import 'dart:collection';
import 'dart:math';

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

final part2 = Part(
  parser: (lines) =>
      lines.map((l) => int.parse(l.split(' ').last) - 1).toList(),
  implementation: (input) {
    final universesToExplore = Queue.of([
      [0, input[0], 0, input[1], 1]
    ]);
    int universes1 = 0;
    int universes2 = 0;
    int iterations = 0;
    while (universesToExplore.isNotEmpty) {
      final universe = universesToExplore.removeLast();
      for (int die1 = 3; die1 <= 9; die1++) {
        final universes = universe[4] * dieCounts[die1];
        final position1 = (universe[1] + die1) % 10;
        final score1 = universe[0] + position1 + 1;
        if (score1 < 21) {
          for (int die2 = 3; die2 <= 9; die2++) {
            final position2 = (universe[3] + die2) % 10;
            final score2 = universe[2] + position2 + 1;
            iterations += 1;
            if (score2 < 21) {
              universesToExplore.add([
                score1,
                position1,
                score2,
                position2,
                universes * dieCounts[die2]
              ]);
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
