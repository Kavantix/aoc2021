import 'dart:async';
import 'dart:io';
import 'dart:isolate';

Future<R> compute<I, R>(FutureOr<R> Function(I) f, I input,
    {String debugName = ''}) async {
  final resultPort = ReceivePort();
  final args = _ComputeArgs<I, R>(resultPort.sendPort, f, input);
  final isolate = await Isolate.spawn<_ComputeArgs<I, R>>(
    _compute,
    args,
    debugName: debugName,
  );
  return await resultPort.first as R;
}

Stream<R> computeMany<I, R>(R Function(I) f, Stream<I> input,
    {String debugName = ''}) async* {
  final resultPort = ReceivePort();
  final args = _ComputeManyArgs<I, R>(resultPort.sendPort, f);
  final isolate = await Isolate.spawn<_ComputeManyArgs<I, R>>(
    _computeMany,
    args,
    debugName: debugName,
  );
  final controller = StreamController<R>();
  final results = resultPort.asBroadcastStream();
  final inputPort = (await results.first) as SendPort;
  int toReceive = 0;
  bool done = false;
  input.listen(
    (data) {
      toReceive += 1;
      inputPort.send(data);
    },
    onDone: () {
      done = true;
      if (toReceive <= 0 && !controller.isClosed) {
        controller.close();
      }
    },
  );
  results.listen(
    (Object? data) {
      controller.add(data as R);
      toReceive -= 1;
      if (done && !controller.isClosed && toReceive <= 0) {
        controller.close();
      }
    },
  );
  await for (final result in controller.stream) {
    yield result;
  }
  isolate.kill();
}

extension FunctionInIsolateExtension<I, R> on R Function(I) {
  Future<R> runInIsolate(I input) => compute(this, input);
  Stream<R> runManyInIsolate(Stream<I> input) => computeMany(this, input);
  Stream<R> runIterableInIsolate(Iterable<I> input) =>
      computeMany(this, Stream.fromIterable(input));
}

extension<T extends Object?> on Iterable<T> {
  Future<List<R>> mapInParallel<R>(R Function(T) f) =>
      Future.wait<R>(map(f.runInIsolate));

  /// Run [f] distributed over the available system treads
  Future<List<R>> mapInParallelGrouped<R>(
    R Function(List<T>) f, {
    int? groups,
  }) {
    groups ??= Platform.numberOfProcessors;
    final list = toList();
    final groupSize = (list.length / groups).ceil();
    return Future.wait([
      for (int i = 0; i < groups; i++)
        f.runInIsolate(list.skip(i * groupSize).take(groupSize).toList()),
    ]);
  }

  Future<List<R>> mapInIsolate<R>(R Function(T) f) =>
      f.runIterableInIsolate(this).toList();
}

class _ComputeArgs<I, R> {
  _ComputeArgs(this.resultPort, this.f, this.input);
  final SendPort resultPort;
  final I input;
  final FutureOr<R> Function(I) f;

  FutureOr<R> run() => f(input);
}

void _compute<I, R>(_ComputeArgs<I, R> args) async {
  final result = args.run();
  if (result is Future<R>) {
    Isolate.exit(args.resultPort, await result);
  } else {
    Isolate.exit(args.resultPort, result);
  }
}

class _ComputeManyArgs<I, R> {
  _ComputeManyArgs(this.resultPort, this.f);
  final SendPort resultPort;
  final R Function(I) f;

  Future<void> run(ReceivePort inputPort) async {
    await for (final i in inputPort) {
      resultPort.send(f(i as I));
    }
  }
}

void _computeMany<I, R>(_ComputeManyArgs<I, R> args) async {
  final inputPort = ReceivePort();
  args.resultPort.send(inputPort.sendPort);
  await args.run(inputPort);
}
