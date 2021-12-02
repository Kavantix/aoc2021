String part1(List<String> lines) {
  final input = lines.map(int.parse).toList();
  int last = input[0];
  int increases = 0;

  for (final number in input) {
    if (number > last) {
      increases += 1;
    }
    last = number;
  }
  return '$increases increases';
}

String part2(List<String> lines) {
  final input = lines.map(int.parse).toList();
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
}
