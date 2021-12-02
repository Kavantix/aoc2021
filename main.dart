#!/usr/bin/env dart

import 'dart:io';
import 'day1/day1.dart' as day1;
import 'day2/day2.dart' as day2;

void main(List<String> args) {
  if (args.length < 3) throw 'Not enough arguments';
  final day = args[0];
  const days = {
    'day1': [day1.part1, day1.part2],
    'day2': [day2.part1, day2.part2],
  };
  final part = int.tryParse(args[1].replaceFirst('part', ''));
  if (part == null || part == 0 || part > 2)
    throw '${args[1]} is not a valid part';
  final filename = args[2];
  final inputFile = File('$day/$filename.txt');
  if (!inputFile.existsSync()) throw '${args[1]}.txt does not exist';
  final lines = inputFile.readAsLinesSync();
  print('Result: ${days[day]![part - 1](lines)}');
}
