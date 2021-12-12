import 'dart:collection';

import '../common.dart';

class Cave {
  Cave(
    this.name,
  )   : isSmall = name.toLowerCase() == name,
        isEnd = name == 'end',
        isStart = name == 'start';

  static int _nextCaveId = 0;

  final id = _nextCaveId++;
  final String name;
  final bool isEnd;
  final bool isStart;
  final bool isSmall;
  final connections = <Cave>[];
}

Map<String, Cave> parseCaves(List<String> lines) {
  final caves = <String, Cave>{};
  for (final line in lines) {
    final from = line.split('-')[0];
    final to = line.split('-')[1];
    final fromCave = caves[from] ??= Cave(from);
    final toCave = caves[to] ??= Cave(to);
    if (!toCave.isStart) fromCave.connections.add(toCave);
    if (!fromCave.isStart) toCave.connections.add(fromCave);
  }
  return caves;
}

class Path {
  Path({
    required this.caves,
    required this.lastCave,
    required this.hasDoubleSmallCave,
  });

  final List<Cave?> caves;
  final Cave lastCave;
  final bool hasDoubleSmallCave;
}

final part1 = Part(
  parser: parseCaves,
  implementation: (caves) {
    final paths = <Path>[];
    final start = caves['start']!;
    final toExplore = Queue<Path>()
      ..add(Path(
        caves: [
          for (final id in range(Cave._nextCaveId))
            if (id == start.id) start else null
        ],
        lastCave: start,
        hasDoubleSmallCave: false,
      ));
    while (toExplore.isNotEmpty) {
      final path = toExplore.removeLast();
      final lastCave = path.lastCave;
      if (lastCave.isEnd) {
        paths.add(path);
        continue;
      }
      for (final cave in lastCave.connections) {
        if (cave.isSmall && path.caves[cave.id] != null) {
          continue;
        }
        final newCaves = List.of(path.caves);
        newCaves[cave.id] = cave;
        toExplore.add(Path(
          caves: newCaves,
          lastCave: cave,
          hasDoubleSmallCave: false,
        ));
      }
    }

    return paths.length.toString();
  },
);

final part2 = Part(
  parser: parseCaves,
  implementation: (caves) {
    int paths = 0;
    final start = caves['start']!;
    final toExplore = [
      Path(
        caves: [
          for (final id in range(Cave._nextCaveId))
            if (id == start.id) start else null
        ],
        lastCave: start,
        hasDoubleSmallCave: false,
      )
    ];
    while (toExplore.isNotEmpty) {
      final path = toExplore.removeLast();
      final lastCave = path.lastCave;
      for (final cave in lastCave.connections) {
        if (cave.isEnd) {
          paths += 1;
          continue;
        }
        if (cave.isSmall &&
            (path.hasDoubleSmallCave && path.caves[cave.id] != null)) {
          continue;
        }
        final newCaves = List.of(path.caves);
        newCaves[cave.id] = cave;
        toExplore.add(Path(
          caves: newCaves,
          lastCave: cave,
          hasDoubleSmallCave: path.hasDoubleSmallCave ||
              (cave.isSmall && path.caves[cave.id] != null),
        ));
      }
    }

    return paths.toString();
  },
);
