#!/usr/bin/env dart

import 'dart:io';

void part1(List<int> input) {
  int last = input[0];
  int increases = 0;

  for (final number in input) {
    if (number > last) {
      increases += 1;
    }
    last = number;
  }
  print('$increases increases');
}

void part2(List<int> input) {
  int last = input[0] + input[1] + input[2];
  int increases = 0;

  for (int i = 0; i < input.length - 2; i++) {
    final sum = input[i] + input[i + 1] + input[i + 2];
    if (sum > last) {
      increases += 1;
    }
    last = sum;
  }
  print('$increases increases');
}

void main(List<String> args) {
  if (args.length < 2) throw 'Not enough arguments';
  const parts = {
    'part1': part1,
    'part2': part2,
  };
  if (!parts.containsKey(args[0])) throw '${args[0]} is not a valid part';
  final inputFile = File(args[1] + '.txt');
  if (!inputFile.existsSync()) throw '${args[1]}.txt does not exist';
  final input = inputFile.readAsLinesSync().map(int.parse).toList();
  parts[args[0]]!(input);
}
