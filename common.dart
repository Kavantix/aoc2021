class Part<T extends Object?> {
  Part({
    required T Function(String line) parser,
    required String Function(List<T>) implementation,
  })  : _parser = parser,
        _implementation = implementation;
  final T Function(String line) _parser;
  final String Function(List<T>) _implementation;

  String run(List<String> lines) =>
      _implementation(lines.map(_parser).toList());
}
