import 'dart:typed_data';

import 'package:struct/struct.dart';
import 'package:struct/constants.dart';
import 'package:test/test.dart';

main() {
  test('pack and unpack max byte identity', () {
    var values = [unsignedByteMax];
    var buffer = pack('B', values);
    var unpacked = unpack('B', buffer);
    expect(unpacked.first, equals(unsignedByteMax));
  });

  test('pack and unpack min byte identity', () {
    var values = [unsignedByteMin];
    var buffer = pack('B', values);
    var unpacked = unpack('B', buffer);
    expect(unpacked.first, equals(unsignedByteMin));
  });

  test('unpack 4 bytes of 255 into unsigned integer', () {
    var values = [255, 255, 255, 255];
    var buffer = pack('BBBB', values);
    var unpacked = unpack('I', buffer);
    expect(unpacked[0], equals(unsignedIntMax));
  });

  test('unpack 1 byte of 127 and 3 bytes of 255 into signed integer', () {
    var values = [127, 255, 255, 255];
    var buffer = pack('BBBB', values);
    var unpacked = unpack('i', buffer);
    expect(unpacked[0], equals(signedIntMax));
  });

  test('unpack 4 bytes of 0 into unsigned integer', () {
    var values = [0, 0, 0, 0];
    var buffer = pack('BBBB', values);
    var unpacked = unpack('I', buffer);
    expect(unpacked[0], equals(0));
  });

  test('unpack 2 bytes into unsigned short', () {
    var values = [255, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('H', buffer);
    expect(unpacked[0], equals(unsignedShortMax));
  });

  test('unpack 8 bytes into unsigned long', () {
    var values = [255, 255, 255, 255, 255, 255, 255, 255];
    var buffer = pack('BBBBBBBB', values);
    var unpacked = unpack('L', buffer);
    expect(unpacked[0], equals(unsignedLongMax));
  });

  test('unpack 2 bytes into unsigned short in big endian (>)', () {
    var values = [1, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('>H', buffer);
    expect(unpacked[0], equals(511));
  });

  test('unpack 2 bytes into unsigned short in big endian (!)', () {
    var values = [1, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('!H', buffer);
    expect(unpacked[0], equals(511));
  });

  test('unpack 2 bytes into unsigned short in little endian (<)', () {
    var values = [1, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('<H', buffer);
    expect(unpacked[0], equals(65281));
  });

  test('unpack 2 bytes into unsigned short in host endian (@)', () {
    var values = [1, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('@H', buffer);
    expect(unpacked[0], equals(65281));
  });

  test('unpack 2 bytes into unsigned short in host endian (=)', () {
    var values = [1, 255];
    var buffer = pack('BB', values);
    var unpacked = unpack('=H', buffer);
    expect(unpacked[0], equals(65281));
  });

  test('pack signed short', () {
    var values = [-20000];
    var buffer = pack('@h', values);
    expect(buffer, Int16List.fromList(values).buffer.asUint8List());
  });

  test('pack unsigned short', () {
    var values = [50000];
    var buffer = pack('@H', values);
    expect(buffer, Uint16List.fromList(values).buffer.asUint8List());
  });

  test('pack signed int', () {
    var values = [-20000];
    var buffer = pack('@i', values);
    expect(buffer, Int32List.fromList(values).buffer.asUint8List());
  });

  test('pack unsigned int', () {
    var values = [50000];
    var buffer = pack('@I', values);
    expect(buffer, Uint32List.fromList(values).buffer.asUint8List());
  });

  test('pack signed long', () {
    var values = [-20000];
    var buffer = pack('@l', values.map((e) => BigInt.from(e)).toList());
    expect(buffer, Int64List.fromList(values).buffer.asUint8List());
  });

  test('pack unsigned long', () {
    var values = [50000];
    var buffer = pack('@l', values.map((e) => BigInt.from(e)).toList());
    expect(buffer, Uint64List.fromList(values).buffer.asUint8List());
  });

  test('unpack signed short', () {
    var values = [-20000];
    var buffer = Int16List.fromList(values).buffer.asUint8List();
    expect(unpack('@h', buffer), values);
  });

  test('unpack unsigned short', () {
    var values = [50000];
    var buffer = Uint16List.fromList(values).buffer.asUint8List();
    expect(unpack('@H', buffer), values);
  });

  test('unpack signed int', () {
    var values = [-20000];
    var buffer = Int32List.fromList(values).buffer.asUint8List();
    expect(unpack('@i', buffer), values);
  });

  test('unpack unsigned int', () {
    var values = [50000];
    var buffer = Uint32List.fromList(values).buffer.asUint8List();
    expect(unpack('@I', buffer), values);
  });

  test('unpack signed long', () {
    var values = [-20000];
    var buffer = Int64List.fromList(values).buffer.asUint8List();
    expect(unpack('@l', buffer), values.map((e) => BigInt.from(e)).toList());
    // var buffer = pack('@l', values.mapexpect(unBigInt.from(e)).bufferoList()), values);
  });

  test('unpack unsigned long', () {
    var values = [50000];
    var buffer = Uint64List.fromList(values).buffer.asUint8List();
    expect(unpack('@L', buffer), values.map((e) => BigInt.from(e)).toList());
  });
}
