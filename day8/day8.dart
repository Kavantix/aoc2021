import '../common.dart';

final part1 = Part(
  parser: (lines) => lines
      .map((line) => line.split(' | ')[1])
      .map((line) => line.split(' ').map((digit) => digit.length))
      .flatten()
      .toList(),
  implementation: (input) {
    const uniqueLengths = {2, 3, 4, 7};
    return input.where(uniqueLengths.contains).length.toString();
  },
);

class Input {
  Input({
    required this.uniqueCombinations,
    required this.outputDigits,
  });
  final List<String> uniqueCombinations;
  final List<String> outputDigits;
}

final part2 = Part(
  parser: (lines) => lines.map(
    (line) => Input(
      uniqueCombinations: line //
          .split(' | ')[0]
          .split(' ')
          .map((d) => (d.split('')..sort()).join())
          .toList(),
      outputDigits: line //
          .split(' | ')[1]
          .split(' ')
          .map((d) => (d.split('')..sort()).join())
          .toList(),
    ),
  ),
  implementation: (input) {
    int total = 0;
    for (final line in input) {
      final one =
          line.uniqueCombinations.firstWhere((digit) => digit.length == 2);
      line.uniqueCombinations.remove(one);
      final three = line.uniqueCombinations.firstWhere((digit) =>
          digit.length == 5 &&
          one.split('').every((letter) => digit.contains(letter)));
      line.uniqueCombinations.remove(three);
      final four =
          line.uniqueCombinations.firstWhere((digit) => digit.length == 4);
      line.uniqueCombinations.remove(four);
      final seven =
          line.uniqueCombinations.firstWhere((digit) => digit.length == 3);
      line.uniqueCombinations.remove(seven);
      final eight =
          line.uniqueCombinations.firstWhere((digit) => digit.length == 7);
      line.uniqueCombinations.remove(eight);
      final a = seven.split('').firstWhere((letter) => !one.contains(letter));
      final nine = line.uniqueCombinations.firstWhere((digit) =>
          digit.length == 6 &&
          digit.split('').where((e) => e != a && !four.contains(e)).length ==
              1);
      line.uniqueCombinations.remove(nine);
      final g = nine
          .split('')
          .firstWhere((letter) => letter != a && !four.contains(letter));
      final d = three
          .split('')
          .firstWhere((letter) => !(a + g + one).contains(letter));
      final zero = (eight.split('')..remove(d)).join('');
      line.uniqueCombinations.remove(zero);
      final six =
          line.uniqueCombinations.firstWhere((digit) => digit.length == 6);
      line.uniqueCombinations.remove(six);
      final c = seven.split('').firstWhere((letter) => !six.contains(letter));
      final two =
          line.uniqueCombinations.firstWhere((digit) => digit.contains(c));
      line.uniqueCombinations.remove(two);
      final five = line.uniqueCombinations.first; // one left
      final mapping = {
        zero: 0,
        one: 1,
        two: 2,
        three: 3,
        four: 4,
        five: 5,
        six: 6,
        seven: 7,
        eight: 8,
        nine: 9,
      };
      final number =
          int.parse(line.outputDigits.map((digit) => mapping[digit]!).join());
      total += number;
    }
    return total.toString();
  },
);
