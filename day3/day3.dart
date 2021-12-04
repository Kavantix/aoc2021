import '../common.dart';

List<List<int>> parseLine(List<String> lines) {
  return [
    for (final line in lines) parseInts(line.split('')),
  ];
}

final part1 = Part(
  parser: parseLine,
  implementation: (input) {
    final result = List<int>.filled(input[0].length, 0);
    for (final number in input) {
      for (int i = 0; i < number.length; i++) {
        result[i] += number[i];
      }
    }
    var gammaString = '';
    var espilonString = '';
    final halfInputLength = input.length ~/ 2;
    for (final count in result) {
      gammaString += count > halfInputLength ? '1' : '0';
      espilonString += count > halfInputLength ? '0' : '1';
    }
    final gamma = int.parse(gammaString, radix: 2);
    final espilon = int.parse(espilonString, radix: 2);
    print('gamma: $gamma, espilon: $espilon');
    return (gamma * espilon).toString();
  },
);

final part2 = Part(
  parser: parseLine,
  implementation: (input) {
    var oxygenNumbers = List.of(input);
    for (int i = 0; i < input.first.length; i++) {
      if (oxygenNumbers.length <= 1) break;
      final halfLength = oxygenNumbers.length / 2;
      int count = 0;
      for (int j = 0; j < oxygenNumbers.length; j++) {
        count += oxygenNumbers[j][i];
      }
      final mask = count >= halfLength ? 1 : 0;
      oxygenNumbers = oxygenNumbers.where((n) => n[i] == mask).toList();
    }
    var co2Numbers = List.of(input);
    for (int i = 0; i < input.first.length; i++) {
      if (co2Numbers.length <= 1) break;
      final halfLength = co2Numbers.length / 2;
      int count = 0;
      for (int j = 0; j < co2Numbers.length; j++) {
        count += co2Numbers[j][i];
      }
      final mask = count >= halfLength ? 0 : 1;
      co2Numbers = co2Numbers.where((n) => n[i] == mask).toList();
    }
    final oxygen = int.parse(oxygenNumbers.first.join(), radix: 2);
    final co2 = int.parse(co2Numbers.first.join(), radix: 2);
    print('oxygen: $oxygen, co2: $co2');
    return (oxygen * co2).toString();
  },
);
