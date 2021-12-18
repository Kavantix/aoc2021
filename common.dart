import 'dart:async';
import 'dart:math' as math;

class Part<T extends Object?> {
  Part({
    required T Function(List<String> lines) parser,
    required FutureOr<String> Function(T) implementation,
  })  : _parser = parser,
        _implementation = implementation;
  final T Function(List<String> lines) _parser;
  final FutureOr<String> Function(T) _implementation;

  FutureOr<String> run(List<String> lines) {
    final sw = Stopwatch()..start();
    final parsed = _parser(lines);
    sw.stop();
    print('Parsing took ${sw.elapsedMicroseconds / 1000} ms');
    return _implementation(parsed);
  }
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

const maxInt64 = 9223372036854775807;

extension IntIterableExtension on Iterable<int> {
  int min() => fold(maxInt64, math.min);
  int max() => fold(-9223372036854775808, math.max);
  int sum() => fold(0, (acc, i) => acc + i);
  int product() => isEmpty ? 0 : skip(1).fold(first, (acc, i) => acc * i);
}

extension IterableOfIterableExtension<T> on Iterable<Iterable<T>> {
  Iterable<T> flatten() => expand((l) => l);
}

extension FunctionExtension2<T1, T2, R> on R Function(T1, T2) {
  R Function(T2) apply(T1 t1) => (T2 t2) => this(t1, t2);
}

Iterable<int> range(int i1, [int? i2]) sync* {
  if (i2 == null) {
    for (int i = 0; i < i1; i++) yield i;
  } else {
    for (int i = i1; i < i2; i++) yield i;
  }
}

int increment(int i) => i + 1;

class Tuple<T1, T2> {
  Tuple(this.value1, this.value2);

  final T1 value1;
  final T2 value2;
}
