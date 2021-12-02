import '../common.dart';

class Instruction {
  Instruction(this.name, this.value);

  static Instruction fromLine(String line) {
    final parts = line.split(' ');
    if (parts.length != 2) throw 'Invalid input: ${line}';
    return Instruction(parts[0], int.parse(parts[1]));
  }

  final String name;
  final int value;
}

final part1 = Part(
  parser: Instruction.fromLine,
  implementation: (input) {
    int depth = 0;
    int position = 0;
    final instructions = {
      'down': (int value) => depth += value,
      'up': (int value) => depth -= value,
      'forward': (int value) => position += value,
    };
    for (final instruction in input) {
      instructions[instruction.name]!(instruction.value);
    }
    print('Position ${position}, Depth $depth');
    return '${position * depth}';
  },
);

final part2 = Part(
  parser: Instruction.fromLine,
  implementation: (input) {
    int aim = 0;
    int depth = 0;
    int position = 0;
    final instructions = {
      'down': (int value) => aim += value,
      'up': (int value) => aim -= value,
      'forward': (int value) {
        depth += aim * value;
        position += value;
      },
    };
    for (final instruction in input) {
      instructions[instruction.name]!(instruction.value);
    }
    print('Position ${position}, Depth $depth');
    return '${position * depth}';
  },
);
