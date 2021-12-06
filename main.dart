#!/usr/bin/env dart --enable-asserts

import 'dart:io';
import 'day1/day1.dart' as day1;
import 'day2/day2.dart' as day2;
import 'day3/day3.dart' as day3;
import 'day4/day4.dart' as day4;
import 'day5/day5.dart' as day5;
import 'day6/day6.dart' as day6;

void main(List<String> args) {
  if (args.length < 3) throw 'Not enough arguments';
  final day = args[0];
  final days = {
    'day1': [day1.part1, day1.part2],
    'day2': [day2.part1, day2.part2],
    'day3': [day3.part1, day3.part2],
    'day4': [day4.part1, day4.part2],
    'day5': [day5.part1, day5.part2],
    'day6': [day6.part1, day6.part2],
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
  print('Result: ${code.run(input)}');
}
