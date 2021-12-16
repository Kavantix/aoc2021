#! /usr/bin/env dart --enable-asserts

import 'day16.dart';

void main() {
  print('BitString');
  {
    final bitString = hexStringToBitStrings('38006F45291200');
    assert(
      bitString == '00111000000000000110111101000101001010010001001000000000',
      'test hexStringToBitStrings, was $bitString',
    );
  }
  print('✓');

  print('Single literal');
  {
    final literalPacketBits = hexStringToBitStrings('D2FE28');
    assert(literalPacketBits == '110100101111111000101000');
    assert(typeIdForPacket(literalPacketBits) == 4);
    final literalPacket = parsePacket('${literalPacketBits}0000000000000');
    assert(literalPacket is LiteralPacket);
    if (literalPacket is! LiteralPacket) throw 'Not a LiteralPacket';
    assert(literalPacket.type == PacketTypes.literal, literalPacket.type.name);
    assert(literalPacket.version == 6, literalPacket.version);
    assert(literalPacket.value == 2021, literalPacket.value);
    assert(literalPacket.length == literalPacketBits.length - 3,
        literalPacket.length - 3);
  }
  print('✓');

  print('simple operator with total length type id');
  {
    final operatorPacketBits = hexStringToBitStrings('38006F45291200');
    final operatorPacket = parsePacket('${operatorPacketBits}0000000');
    assert(operatorPacket is OperatorPacket);
    if (operatorPacket is! OperatorPacket) throw 'Not an OperatorPacket';
    assert(operatorPacket.type == PacketTypes.op, operatorPacket.type.name);
    assert(operatorPacket.version == 1, operatorPacket.version);
    assert(operatorPacket.subPackets.length == 2,
        operatorPacket.subPackets.length);
    final operatorPacketSubPacket1 = operatorPacket.subPackets[0];
    assert(operatorPacketSubPacket1.version == 6,
        operatorPacketSubPacket1.version);
    assert(
        operatorPacketSubPacket1.length == 11, operatorPacketSubPacket1.length);
    assert(operatorPacketSubPacket1 is LiteralPacket);
    if (operatorPacketSubPacket1 is! LiteralPacket) return;
    assert(
        operatorPacketSubPacket1.value == 10, operatorPacketSubPacket1.value);
    final operatorPacketSubPacket2 = operatorPacket.subPackets[1];
    assert(
        operatorPacketSubPacket2.length == 16, operatorPacketSubPacket2.length);
    assert(operatorPacketSubPacket2 is LiteralPacket);
    if (operatorPacketSubPacket2 is! LiteralPacket) return;
    assert(
        operatorPacketSubPacket2.value == 20, operatorPacketSubPacket2.value);
  }
  print('✓');

  print('simple operator with number of sub packets type id');
  {
    final operatorPacketBits = hexStringToBitStrings('EE00D40C823060');
    final operatorPacket = parsePacket('${operatorPacketBits}0000000');
    assert(operatorPacket is OperatorPacket);
    if (operatorPacket is! OperatorPacket) throw 'Not an OperatorPacket';
    assert(operatorPacket.type == PacketTypes.op, operatorPacket.type.name);
    assert(operatorPacket.version == 7, operatorPacket.version);
    assert(operatorPacket.subPackets.length == 3,
        operatorPacket.subPackets.length);
    final operatorPacketSubPacket1 = operatorPacket.subPackets[0];
    assert(operatorPacketSubPacket1.version == 2,
        operatorPacketSubPacket1.version);
    assert(
        operatorPacketSubPacket1.length == 11, operatorPacketSubPacket1.length);
    assert(operatorPacketSubPacket1 is LiteralPacket);
    if (operatorPacketSubPacket1 is! LiteralPacket) return;
    assert(operatorPacketSubPacket1.value == 1, operatorPacketSubPacket1.value);
    final operatorPacketSubPacket2 = operatorPacket.subPackets[1];
    assert(
        operatorPacketSubPacket2.length == 11, operatorPacketSubPacket2.length);
    assert(operatorPacketSubPacket2 is LiteralPacket);
    if (operatorPacketSubPacket2 is! LiteralPacket) return;
    assert(operatorPacketSubPacket2.value == 2, operatorPacketSubPacket2.value);
    final operatorPacketSubPacket3 = operatorPacket.subPackets[2];
    assert(
        operatorPacketSubPacket3.length == 11, operatorPacketSubPacket3.length);
    assert(operatorPacketSubPacket3 is LiteralPacket);
    if (operatorPacketSubPacket3 is! LiteralPacket) return;
    assert(operatorPacketSubPacket3.value == 3, operatorPacketSubPacket3.value);
  }
  print('✓');

  print('Operator packet that contains nested operator with value');
  {
    final operatorPacketBits = hexStringToBitStrings('8A004A801A8002F478');
    final operatorPacket = parsePacket('${operatorPacketBits}0000000');
    assert(operatorPacket is OperatorPacket);
    if (operatorPacket is! OperatorPacket) throw 'Not an OperatorPacket';
    assert(operatorPacket.type == PacketTypes.op, operatorPacket.type.name);
    assert(operatorPacket.version == 4, operatorPacket.version);
    assert(operatorPacket.subPackets.length == 1,
        operatorPacket.subPackets.length);
    final operatorPacketSubPacket1 = operatorPacket.subPackets[0];
    assert(operatorPacketSubPacket1.version == 1,
        operatorPacketSubPacket1.version);
    assert(operatorPacketSubPacket1 is OperatorPacket);
    if (operatorPacketSubPacket1 is! OperatorPacket) return;
    assert(operatorPacketSubPacket1.subPackets.length == 1,
        operatorPacketSubPacket1.subPackets.length);
    final packetVersionSum = versionSumForPacket(operatorPacket);
    assert(packetVersionSum == 16, packetVersionSum);
  }
  print('✓');

  print('Packet example 2');
  {
    final packet = packetFromHexString('620080001611562C8802118E34');
    final packetVersionSum = versionSumForPacket(packet);
    assert(packetVersionSum == 12, packetVersionSum);
  }
  print('✓');

  print('Packet example 3');
  {
    final packet = packetFromHexString('C0015000016115A2E0802F182340');
    final packetVersionSum = versionSumForPacket(packet);
    assert(packetVersionSum == 23, packetVersionSum);
  }
  print('✓');
}
