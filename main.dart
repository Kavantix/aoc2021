#!/usr/bin/env dart --enable-asserts

import 'dart:async';
import 'dart:io';
import 'common.dart';
import 'day1/day1.dart' as day1;
import 'day2/day2.dart' as day2;
import 'day3/day3.dart' as day3;
import 'day4/day4.dart' as day4;
import 'day5/day5.dart' as day5;
import 'day6/day6.dart' as day6;
import 'day7/day7.dart' as day7;
import 'day8/day8.dart' as day8;
import 'day9/day9.dart' as day9;
import 'day10/day10.dart' as day10;
import 'day11/day11.dart' as day11;
import 'day12/day12.dart' as day12;
import 'day13/day13.dart' as day13;
import 'day14/day14.dart' as day14;
import 'day15/day15.dart' as day15;
import 'day16/day16.dart' as day16;
import 'day17/day17.dart' as day17;
import 'day18/day18.dart' as day18;
import 'day19/day19.dart' as day19;
import 'day20/day20.dart' as day20;
import 'day21/day21.dart' as day21;
import 'day22/day22.dart' as day22;
import 'simple_isolate.dart';

final days = {
  'day1': [day1.part1, day1.part2],
  'day2': [day2.part1, day2.part2],
  'day3': [day3.part1, day3.part2],
  'day4': [day4.part1, day4.part2],
  'day5': [day5.part1, day5.part2],
  'day6': [day6.part1, day6.part2],
  'day7': [day7.part1, day7.part2],
  'day8': [day8.part1, day8.part2],
  'day9': [day9.part1, day9.part2],
  'day10': [day10.part1, day10.part2],
  'day11': [day11.part1, day11.part2],
  'day12': [day12.part1, day12.part2],
  'day13': [day13.part1, day13.part2],
  'day14': [day14.part1, day14.part2],
  'day15': [day15.part1, day15.part2],
  'day16': [day16.part1, day16.part2],
  'day17': [day17.part1, day17.part2],
  'day18': [day18.part1, day18.part2],
  'day19': [day19.part1, day19.part2],
  'day20': [day20.part1, day20.part2],
  'day21': [day21.part1, day21.part2],
  'day22': [day22.part1, day22.part2],
};

void main(List<String> args) async {
  bool runAll = false;
  if (args.length == 1 && args[0] == 'all') {
    runAll = true;
  } else if (args.length < 3) throw 'Not enough arguments';
  if (runAll) {
    final sw = Stopwatch()..start();
    final timeFutures = <Future<int>>[];
    final resultFutures = <Future<String>>[];
    print('Warming up...');
    for (final i in range(4)) {
      if (i == 3) {
        sw.stop();
        print('Warmup took ${sw.elapsedMicroseconds / 1000} ms');
        sw.reset();
        sw.start();
      }
      await runZoned(
        () async {
          timeFutures.clear();
          resultFutures.clear();
          for (final day in days.keys) {
            for (final part in range(2)) {
              final result = compute((_) async {
                final result = await runZoned(
                  () async {
                    return await runDay(day, part + 1, 'input');
                  },
                  zoneSpecification: ZoneSpecification(
                    print: (_, __, ___, ____) {},
                  ),
                );
                return result;
              }, null);
              resultFutures.add(
                result.then((result) =>
                    'Parallel day $day part ${part + 1} took ${result / 1000} ms'),
              );
              timeFutures.add(result);
            }
          }
          await Future.wait(timeFutures);
          (await Future.wait(resultFutures)).forEach(print);
        },
        zoneSpecification: ZoneSpecification(
          print: i == 3 ? null : (_, __, ___, ____) {},
        ),
      );
    }
    print('');
    final asyncTime = sw.elapsedMicroseconds;
    final times = <int>[];
    for (final day in days.keys) {
      for (final part in range(2)) {
        final elapsedMicroseconds = await compute((_) async {
          final result = await runZoned(
            () async {
              return await runDay(day, part + 1, 'input');
            },
            zoneSpecification: ZoneSpecification(
              print: (_, __, ___, ____) {},
            ),
          );
          print(
              'Sequential day $day part ${part + 1} took ${result / 1000} ms');
          return result;
        }, null);
        times.add(elapsedMicroseconds);
        // sw.reset();
      }
    }
    sw.stop();
    print(
        'Total parallel time: ${(await Future.wait(timeFutures)).sum() / 1000} ms');
    print('Parallel real time:  ${asyncTime / 1000} ms');
    print('Total sequential time: ${times.sum() / 1000} ms');
    print(
        'Sequential real time:  ${(sw.elapsedMicroseconds - asyncTime) / 1000} ms');
  } else {
    final day = args[0];
    if (!days.containsKey(day)) throw '$day is not a valid day';
    final part = int.tryParse(args[1].replaceFirst('part', ''));
    if (part == null || part == 0 || part > 2)
      throw '${args[1]} is not a valid part';
    await runDay(day, part, args[2]);
  }
  exit(0);
}

Future<int> runDay(String day, int part, String filename) async {
  final inputFile = File('$day/$filename.txt');
  if (!inputFile.existsSync()) throw '${inputFile.path} does not exist';
  final code = days[day]![part - 1];
  final input = inputFile.readAsLinesSync();
  final sw = Stopwatch()..start();
  final resultOrFuture = code.run(input);
  final String result;
  if (resultOrFuture is Future<String>) {
    result = await resultOrFuture;
  } else {
    result = resultOrFuture;
  }
  print('Result: $result\nIn: ${sw.elapsedMicroseconds / 1000} ms');
  sw.stop();
  return sw.elapsedMicroseconds;
}
