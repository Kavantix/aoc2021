import '../common.dart';

enum FoldDirections { up, left }

class Fold {
  Fold(this.direction, this.value);

  final FoldDirections direction;
  final int value;
}

class Input {
  Input({
    required this.paper,
    required this.folds,
  });
  final List<List<int>> paper;
  final List<Fold> folds;

  static Input fromLines(List<String> lines) {
    final pointLines = lines.takeWhile((l) => l.isNotEmpty).toList();
    final foldLiness = lines.skip(pointLines.length + 1).toList();
    final points =
        pointLines.map((l) => l.split(',').map(int.parse).toList()).toList();
    final maxX = points.map((p) => p[0]).max();
    final maxY = points.map((p) => p[1]).max();
    final paper = List.generate(
        maxY + (maxY.isEven ? 1 : 2), (_) => List.filled(maxX + 1, 0));
    for (final point in points) {
      paper[point[1]][point[0]] = 1;
    }
    final folds = <Fold>[];
    final foldRegex = RegExp(r'fold along (x|y)=(\d+)');
    for (final fold in foldLiness) {
      final match = foldRegex.firstMatch(fold)!;
      switch (match.group(1)) {
        case 'x':
          folds.add(Fold(FoldDirections.left, int.parse(match.group(2)!)));
          break;
        case 'y':
          folds.add(Fold(FoldDirections.up, int.parse(match.group(2)!)));
          break;
      }
    }
    return Input(
      paper: paper,
      folds: folds,
    );
  }
}

void printPaper(List<List<int>> paper) {
  for (final row in paper) {
    var rowString = '';
    for (final column in row) {
      rowString += column > 0 ? '██' : '  ';
    }
    print(rowString);
  }
}

Part<Input> partWhere({int? max}) => Part(
      parser: Input.fromLines,
      implementation: (input) {
        var paper = input.paper;
        // printPaper(paper);
        // print('');
        for (final fold in input.folds.take(max ?? input.folds.length)) {
          final foldPosition = fold.value;
          switch (fold.direction) {
            case FoldDirections.up:
              assert(paper[foldPosition].sum() == 0,
                  'real: ${paper[foldPosition].sum()}, foldPosition: $foldPosition, ${paper.length}');
              print('foldPosition y: $foldPosition, ${paper.length}');
              final newPaper = paper.take(foldPosition).toList();
              int row = 0;
              for (final line
                  in paper.reversed.take(paper.length - foldPosition - 1)) {
                for (int column = 0; column < line.length; column++) {
                  newPaper[row][column] += line[column];
                }
                row += 1;
              }
              paper = newPaper;
              break;
            case FoldDirections.left:
              final newPaper =
                  paper.map((l) => l.take(foldPosition).toList()).toList();
              int row = 0;
              assert(paper.map((l) => l[foldPosition]).sum() == 0,
                  'foldPosition: $foldPosition, ${paper.first.length}');
              final foldColumns = paper.first.length - foldPosition - 1;
              print('foldPosition x: $foldPosition, ${paper.first.length}');
              for (final line in paper) {
                int column = 0;
                for (final point in line.reversed.take(foldColumns)) {
                  newPaper[row][column] += point;
                  column += 1;
                }
                row += 1;
              }
              paper = newPaper;
              break;
          }
          // printPaper(paper);
          // print('');
        }
        if (max == null) printPaper(paper);
        return paper.flatten().where((i) => i > 0).length.toString();
      },
    );

final part1 = partWhere(max: 1);
final part2 = partWhere(max: null);
