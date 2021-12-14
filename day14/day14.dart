import '../common.dart';

class Instruction {
  Instruction({
    required this.match,
    required this.insert,
  });

  final String match;
  final String insert;

  Instruction.fromString(String s)
      : match = s.split(' -> ')[0],
        insert = s.split(' -> ')[1];
}

class Input {
  Input({
    required this.template,
    required this.instructions,
  });
  final String template;
  final List<Instruction> instructions;

  Input.fromLines(List<String> lines)
      : template = lines.first,
        instructions =
            lines.skip(2).map<Instruction>(Instruction.fromString).toList();
}

final partWhere = ({required int steps}) => Part(
      parser: Input.fromLines,
      implementation: (input) {
        var pairs = <String, int>{};
        for (final match in input.instructions.map((i) => i.match)) {
          assert(!pairs.containsKey(match));
          pairs[match] = 0;
        }
        for (int i = 0; i < input.template.length - 1; i++) {
          final submatch = input.template.substring(i, i + 2);
          pairs.update(submatch, increment);
        }
        for (final _ in range(steps)) {
          final newPairs = Map.of(pairs);
          for (final instruction in input.instructions) {
            final count = pairs[instruction.match]!;
            final replacement1 =
                instruction.match.substring(0, 1) + instruction.insert;
            final replacement2 =
                instruction.insert + instruction.match.substring(1, 2);
            newPairs.update(instruction.match, (i) => i - count);
            newPairs.update(replacement1, (i) => i + count);
            newPairs.update(replacement2, (i) => i + count);
          }
          pairs = newPairs;
        }
        final letters = <String, int>{
          input.template.split('').last: 1,
        };
        for (final entry in pairs.entries) {
          final letter = entry.key.substring(0, 1);
          letters.update(letter, (i) => i + entry.value,
              ifAbsent: () => entry.value);
        }
        print('Total letters: ${pairs.values.sum() + 1}');
        final mostCommon = letters.entries
            .fold<MapEntry<String, int>>(letters.entries.first, (acc, entry) {
          return entry.value > acc.value ? entry : acc;
        });
        print('mostCommon: ${mostCommon.key} (${mostCommon.value})');
        final leastCommon = letters.entries
            .fold<MapEntry<String, int>>(letters.entries.first, (acc, entry) {
          return entry.value < acc.value ? entry : acc;
        });
        print('leastCommon: ${leastCommon.key} (${leastCommon.value})');
        return (mostCommon.value - leastCommon.value).toString();
      },
    );

final part1 = partWhere(steps: 10);
final part2 = partWhere(steps: 40);
