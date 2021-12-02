#!/usr/bin/env dart

import 'dart:io';

class Instruction {
  Instruction(this.name, this.value);

  final String name;
  final int value;
}

void part1(List<Instruction> input) {
  int depth = 0;
  int position = 0;
  final instructions = {
    'down': (int value) => depth += value,
    'up': (int value) => depth -= value,
    'forward': (int value) => position += value,
  };
  for (final instruction in input) {
    instructions[instruction.name]!(instruction.value);
  }
  print('Position ${position}, Depth $depth, result ${position * depth}');
}

void part2(List<Instruction> input) {
  int aim = 0;
  int depth = 0;
  int position = 0;
  final instructions = {
    'down': (int value) => aim += value,
    'up': (int value) => aim -= value,
    'forward': (int value) {
      depth += aim * value;
      position += value;
    },
  };
  for (final instruction in input) {
    instructions[instruction.name]!(instruction.value);
  }
  print('Position ${position}, Depth $depth, result ${position * depth}');
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
  final input = inputFile.readAsLinesSync().map((line) {
    final parts = line.split(' ');
    if (parts.length != 2) throw 'Invalid input: ${line}';
    return Instruction(parts[0], int.parse(parts[1]));
  }).toList();
  parts[args[0]]!(input);
}
