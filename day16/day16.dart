import 'dart:collection';

import '../common.dart';

enum PacketTypes { literal, op }

abstract class Packet {
  Packet({
    required this.version,
    required this.typeId,
    required this.length,
  });
  final int version;
  final int typeId;
  final int length;
  PacketTypes get type;
}

class LiteralPacket extends Packet {
  LiteralPacket({
    required int version,
    required int typeId,
    required int length,
    required this.value,
  })  : assert(typeId == 4),
        super(
          version: version,
          typeId: typeId,
          length: length,
        );

  final int value;

  @override
  PacketTypes get type => PacketTypes.literal;
}

class OperatorPacket extends Packet {
  OperatorPacket({
    required int version,
    required int typeId,
    required int length,
    required this.subPackets,
  }) : super(
          version: version,
          typeId: typeId,
          length: length,
        );

  final List<Packet> subPackets;
  @override
  PacketTypes get type => PacketTypes.op;
}

String hexStringToBitStrings(String input) => input
    .split('')
    .map((n) => int.parse(n, radix: 16))
    .map((n) => n.toRadixString(2).padLeft(4, '0'))
    .join();

Packet parsePacket(String bits) {
  final typeId = typeIdForPacket(bits);
  if (typeId == 4) {
    return parseLiteralPacket(bits);
  } else {
    return parseOperatorPacket(bits);
  }
}

LiteralPacket parseLiteralPacket(String bits) {
  final version = versionForPacket(bits);
  final typeId = typeIdForPacket(bits);
  assert(typeId == 4);
  String valueBits = '';
  int position = 6;
  while (true) {
    final isLastGroup = bits.substring(position, position + 1) == '0';
    valueBits += bits.substring(position + 1, position + 5);
    position += 5;
    if (isLastGroup) break;
  }
  return LiteralPacket(
    version: version,
    typeId: typeId,
    value: int.parse(valueBits, radix: 2),
    length: position,
  );
}

OperatorPacket parseOperatorPacket(String bits) {
  final version = versionForPacket(bits);
  final typeId = typeIdForPacket(bits);
  assert(typeId != 4);
  final lengthTypeIsTotal = bits.substring(6, 7) == '0';
  final subPackets = <Packet>[];
  int length = 7;
  if (lengthTypeIsTotal) {
    final totalLengthBits = bits.substring(7, 7 + 15);
    final totalLength = int.parse(totalLengthBits, radix: 2);
    length += 15;
    int position = 7 + 15;
    final end = position + totalLength;
    while (position < end) {
      final packetBits = bits.substring(position);
      final subPacket = parsePacket(packetBits);
      position += subPacket.length;
      subPackets.add(subPacket);
      length += subPacket.length;
    }
  } else {
    final numSubPacketsBits = bits.substring(7, 7 + 11);
    final numSubPackets = int.parse(numSubPacketsBits, radix: 2);
    length += 11;
    int position = 7 + 11;
    while (subPackets.length < numSubPackets) {
      final packetBits = bits.substring(position);
      final subPacket = parsePacket(packetBits);
      position += subPacket.length;
      subPackets.add(subPacket);
      length += subPacket.length;
    }
  }

  return OperatorPacket(
    version: version,
    typeId: typeId,
    length: length,
    subPackets: subPackets,
  );
}

int typeIdForPacket(String bits) {
  assert(bits.length >= 3);
  return int.parse(bits.substring(3, 6), radix: 2);
}

int versionForPacket(String bits) {
  assert(bits.length >= 3);
  return int.parse(bits.substring(0, 3), radix: 2);
}

int versionSumForPacket(Packet packet) {
  int sum = 0;
  final queue = Queue.of([packet]);
  while (queue.isNotEmpty) {
    final packet = queue.removeLast();
    switch (packet.type) {
      case PacketTypes.literal:
        sum += packet.version;
        break;
      case PacketTypes.op:
        if (packet is! OperatorPacket) throw 'unreachable';
        sum += packet.version;
        queue.addAll(packet.subPackets);
        break;
    }
  }

  return sum;
}

Packet packetFromHexString(String hexString) {
  final bits = hexStringToBitStrings(hexString);
  return parsePacket(bits);
}

// Packet parsePacket(String bits) {
//   // final version =
// }

// List<Packet> parsePackets(String input) {

// }

final part1 = Part(
  parser: (lines) => packetFromHexString(lines.first),
  implementation: (input) {
    return versionSumForPacket(input).toString();
  },
);

final part2 = Part(
  parser: parseInts,
  implementation: (input) {
    int last = input[0] + input[1] + input[2];
    int increases = 0;

    for (int i = 0; i < input.length - 2; i++) {
      final sum = input[i] + input[i + 1] + input[i + 2];
      if (sum > last) {
        increases += 1;
      }
      last = sum;
    }
    return '$increases increases';
  },
);
