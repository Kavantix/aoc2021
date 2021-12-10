import 'dart:collection';

import '../common.dart';

final part1 = Part(
  parser: (lines) => lines.map((l) => l.split('')).toList(),
  implementation: (input) {
    final stack = Queue<String>();
    final illegals = <String>[];
    const openers = '{([<';
    const closers = '})]>';
    for (final line in input) {
      for (final c in line) {
        if (openers.contains(c)) {
          stack.add(c);
        } else if (closers.contains(c)) {
          final opener = stack.removeLast();
          if (openers.indexOf(opener) != closers.indexOf(c)) {
            illegals.add(c);
            break;
          }
        } else {
          throw 'Unreachabe';
        }
      }
      stack.clear();
    }

    const scores = {
      ')': 3,
      ']': 57,
      '}': 1197,
      '>': 25137,
    };

    return illegals.map((c) => scores[c]!).sum().toString();
  },
);

final part2 = Part(
  parser: (lines) => lines.map((l) => l.split('')).toList(),
  implementation: (input) {
    final legalStacks = <Queue<String>>[];
    const openers = '{([<';
    const closers = '})]>';
    for (final line in input) {
      bool isLegal = true;
      final stack = Queue<String>();
      for (final c in line) {
        if (openers.contains(c)) {
          stack.add(c);
        } else if (closers.contains(c)) {
          final opener = stack.removeLast();
          if (openers.indexOf(opener) != closers.indexOf(c)) {
            isLegal = false;
            break;
          }
        } else {
          throw 'Unreachabe';
        }
      }
      if (isLegal && stack.isNotEmpty) {
        legalStacks.add(stack);
      }
    }

    const scores = {
      '(': 1,
      '[': 2,
      '{': 3,
      '<': 4,
    };

    final legals = legalStacks.map((stack) {
      int score = 0;
      while (stack.isNotEmpty) {
        score = score * 5 + scores[stack.removeLast()]!;
      }
      return score;
    }).toList();
    legals.sort();

    return legals[legals.length ~/ 2].toString();
  },
);
