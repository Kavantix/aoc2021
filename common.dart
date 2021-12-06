class Part<T extends Object?> {
  Part({
    required T Function(List<String> lines) parser,
    required String Function(T) implementation,
  })  : _parser = parser,
        _implementation = implementation;
  final T Function(List<String> lines) _parser;
  final String Function(T) _implementation;

  String run(List<String> lines) => _implementation(_parser(lines));
}

extension ListExtensions<T> on List<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

List<int> parseInts(Iterable<String> values) => values.map(int.parse).toList();

extension IntIterableExtension on Iterable<int> {
  int sum() => fold(0, (acc, i) => acc + i);
}

extension ListOfListExtension<T> on List<List<T>> {
  Iterable<T> flatten() => expand((l) => l);
}
