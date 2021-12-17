#!/usr/bin/env dart --enable-asserts

import 'dart:io';
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

void main(List<String> args) async {
  final sw = Stopwatch()..start();
  if (args.length < 3) throw 'Not enough arguments';
  final day = args[0];
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
  };
  if (!days.containsKey(day)) throw '$day is not a valid day';
  final part = int.tryParse(args[1].replaceFirst('part', ''));
  if (part == null || part == 0 || part > 2)
    throw '${args[1]} is not a valid part';
  final filename = args[2];
  final inputFile = File('$day/$filename.txt');
  if (!inputFile.existsSync()) throw '$day/${args[1]}.txt does not exist';
  final code = days[day]![part - 1];
  final input = inputFile.readAsLinesSync();
  final resultOrFuture = code.run(input);
  final String result;
  if (resultOrFuture is Future<String>) {
    result = await resultOrFuture;
  } else {
    result = resultOrFuture;
  }
  sw.stop();
  print('Result: $result\nin ${sw.elapsedMicroseconds / 1000} ms');
}
