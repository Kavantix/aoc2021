import '../common.dart';

class Cube {
  Cube(
    this.startX,
    this.startY,
    this.startZ,
    this.endX,
    this.endY,
    this.endZ,
  );

  Cube.fromList(List<List<int>> p)
      : startX = p[0][0],
        startY = p[1][0],
        startZ = p[2][0],
        endX = p[0][1],
        endY = p[1][1],
        endZ = p[2][1];

  final int startX, startY, startZ;
  final int endX, endY, endZ;

  String toString() => '($startX, $startY, $startZ .. $endX, $endY, $endZ)';

  bool overlapsWith(Cube other) =>
      other.startX <= endX &&
      other.endX >= startX &&
      other.startY <= endY &&
      other.endY >= startY &&
      other.startZ <= endZ &&
      other.endZ >= startZ;

  int get volume =>
      (endX - startX + 1) * (endY - startY + 1) * (endZ - startZ + 1);

  Iterable<Cube> cubesAfterSubtracting(Cube other) {
    other = Cube(
      other.startX < startX ? startX : other.startX,
      other.startY < startY ? startY : other.startY,
      other.startZ < startZ ? startZ : other.startZ,
      other.endX > endX ? endX : other.endX,
      other.endY > endY ? endY : other.endY,
      other.endZ > endZ ? endZ : other.endZ,
    );
    final tlf = Cube(
      startX,
      startY,
      startZ,
      other.startX - 1,
      other.startY - 1,
      other.startZ - 1,
    );
    final tlm = Cube(
      startX,
      startY,
      other.startZ,
      other.startX - 1,
      other.startY - 1,
      other.endZ,
    );
    final tlb = Cube(
      startX,
      startY,
      other.endZ + 1,
      other.startX - 1,
      other.startY - 1,
      endZ,
    );
    // final c1 =
    //     Cube(startX, startY, startZ, other.startX - 1, other.startY - 1, endZ);
    // assert(tlf.volume + tlm.volume + tlb.volume == c1.volume,
    //     '\n${tlf.volume + tlm.volume + tlb.volume}, ${c1.volume}');
    final tmf = Cube(
      other.startX,
      startY,
      startZ,
      other.endX,
      other.startY - 1,
      other.startZ - 1,
    );
    final tmm = Cube(
      other.startX,
      startY,
      other.startZ,
      other.endX,
      other.startY - 1,
      other.endZ,
    );
    final tmb = Cube(
      other.startX,
      startY,
      other.endZ + 1,
      other.endX,
      other.startY - 1,
      endZ,
    );
    // final c2 =
    //     Cube(other.startX, startY, startZ, other.endX, other.startY - 1, endZ);
    // assert(tmf.volume + tmm.volume + tmb.volume == c2.volume,
    //     '\n${tmf.volume + tmm.volume + tmb.volume}, ${c2.volume}');
    final trf = Cube(
      other.endX + 1,
      startY,
      startZ,
      endX,
      other.startY - 1,
      other.startZ - 1,
    );
    final trm = Cube(
      other.endX + 1,
      startY,
      other.startZ,
      endX,
      other.startY - 1,
      other.endZ,
    );
    final trb = Cube(
      other.endX + 1,
      startY,
      other.endZ + 1,
      endX,
      other.startY - 1,
      endZ,
    );
    // final c3 =
    //     Cube(other.endX + 1, startY, startZ, endX, other.startY - 1, endZ);
    // assert(tmf.volume + tmm.volume + tmb.volume == c3.volume,
    //     '\n${trf.volume + trm.volume + trb.volume}, ${c3.volume}');
    // final top = Cube(startX, startY, startZ, endX, other.startY - 1, endZ);
    // assert(c1.volume + c2.volume + c3.volume == top.volume,
    //     '\n${c1.volume + c2.volume + c3.volume}, ${top.volume}');
    final mlf = Cube(
      startX,
      other.startY,
      startZ,
      other.startX - 1,
      other.endY,
      other.startZ - 1,
    );
    final mlm = Cube(
      startX,
      other.startY,
      other.startZ,
      other.startX - 1,
      other.endY,
      other.endZ,
    );
    final mlb = Cube(
      startX,
      other.startY,
      other.endZ + 1,
      other.startX - 1,
      other.endY,
      endZ,
    );
    final mmf = Cube(
      other.startX,
      other.startY,
      startZ,
      other.endX,
      other.endY,
      other.startZ - 1,
    );
    final mmb = Cube(
      other.startX,
      other.startY,
      other.endZ + 1,
      other.endX,
      other.endY,
      endZ,
    );
    final mrf = Cube(
      other.endX + 1,
      other.startY,
      startZ,
      endX,
      other.endY,
      other.startZ - 1,
    );
    final mrm = Cube(
      other.endX + 1,
      other.startY,
      other.startZ,
      endX,
      other.endY,
      other.endZ,
    );
    final mrb = Cube(
      other.endX + 1,
      other.startY,
      other.endZ + 1,
      endX,
      other.endY,
      endZ,
    );
    final blf = Cube(
      startX,
      other.endY + 1,
      startZ,
      other.startX - 1,
      endY,
      other.startZ - 1,
    );
    final blm = Cube(
      startX,
      other.endY + 1,
      other.startZ,
      other.startX - 1,
      endY,
      other.endZ,
    );
    final blb = Cube(
      startX,
      other.endY + 1,
      other.endZ + 1,
      other.startX - 1,
      endY,
      endZ,
    );
    final bmf = Cube(
      other.startX,
      other.endY + 1,
      startZ,
      other.endX,
      endY,
      other.startZ - 1,
    );
    final bmm = Cube(
      other.startX,
      other.endY + 1,
      other.startZ,
      other.endX,
      endY,
      other.endZ,
    );
    final bmb = Cube(
      other.startX,
      other.endY + 1,
      other.endZ + 1,
      other.endX,
      endY,
      endZ,
    );
    final brf = Cube(
      other.endX + 1,
      other.endY + 1,
      startZ,
      endX,
      endY,
      other.startZ - 1,
    );
    final brm = Cube(
      other.endX + 1,
      other.endY + 1,
      other.startZ,
      endX,
      endY,
      other.endZ,
    );
    final brb = Cube(
      other.endX + 1,
      other.endY + 1,
      other.endZ + 1,
      endX,
      endY,
      endZ,
    );
    return [
      tlf,
      tlm,
      tlb,
      tmf,
      tmm,
      tmb,
      trf,
      trm,
      trb,
      mlf,
      mlm,
      mlb,
      mmf,
      mmb,
      mrf,
      mrm,
      mrb,
      blf,
      blm,
      blb,
      bmf,
      bmm,
      bmb,
      brf,
      brm,
      brb,
    ].where((c) => c.volume > 0);
  }
}

class Instruction {
  // ignore: avoid_positional_boolean_parameters
  Instruction(this.turnOn, List<List<int>> points)
      : cube = Cube.fromList(points);
  final bool turnOn;
  final Cube cube;
}

final partWhere = (bool Function(Instruction i) test) => Part(
      parser: (lines) => lines
          .map((l) => Instruction(
                l.split(' ')[0] == 'on',
                l
                    .split(' ')[1]
                    .split(',')
                    .map((n) =>
                        n.split('=')[1].split('..').map(int.parse).toList())
                    .toList(),
              ))
          .takeWhile(test),
      implementation: (instructions) {
        final cubes = <Cube>{};
        for (final instruction in instructions) {
          final overlappingCubes =
              cubes.where((c) => c.overlapsWith(instruction.cube)).toList();
          if (overlappingCubes.isEmpty) {
            if (instruction.turnOn) {
              cubes.add(instruction.cube);
            }
            continue;
          }
          if (instruction.turnOn) {
            final newCubes = <Cube>[instruction.cube];
            for (final overlapping in overlappingCubes) {
              for (int i = newCubes.length - 1; i >= 0; i--) {
                final cube = newCubes[i];
                if (!cube.overlapsWith(overlapping)) continue;
                newCubes.removeAt(i);
                final nonOverlapping = cube.cubesAfterSubtracting(overlapping);
                newCubes.addAll(nonOverlapping);
              }
            }
            cubes.addAll(newCubes);
          } else {
            for (final overlapping in overlappingCubes) {
              cubes.remove(overlapping);
              cubes.addAll(overlapping.cubesAfterSubtracting(instruction.cube));
            }
          }
        }
        return cubes.map((c) => c.volume).sum().toString();
      },
    );

final part1 = partWhere((instruction) =>
    instruction.cube.startX.abs() <= 50 && instruction.cube.endX.abs() <= 50);
final part2 = partWhere((_) => true);
