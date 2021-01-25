library struct;

import 'dart:typed_data';

import './constants.dart';

// @	native	native	native
// =	native	standard	none
// <	little-endian	standard	none
// >	big-endian	standard	none
// !	network (= big-endian)	standard	none

List unpack(String format, Uint8List data) {
  if (format == null || format == '') {
    throw new ArgumentError('Format string must have a value');
  }

  var length = calculateSize(format);

  if (length != data.length) {
    throw new FormatException(
        'Format string length does not match buffer length');
  }

  List output = [];
  ByteData bytes =
      new ByteData.view(data.buffer, data.offsetInBytes, data.length);

  Endian endian;

  int index = 0;

  int i = 0;

  var firstChar = format[index];
  if (firstChar == '@' || firstChar == '=') {
    endian = Endian.host;
    i = 1;
  } else if (firstChar == '<') {
    endian = Endian.little;
    i = 1;
  } else if (firstChar == '>' || firstChar == '!') {
    endian = Endian.big;
    i = 1;
  }

  for (; i < format.length; i++) {
    var ch = format[i];

    switch (ch) {
      case 'x':
        index += 1;
        break;
      case 'b':
        var byte = bytes.getInt8(index);
        output.add(byte);
        index += 1;
        break;
      case 'B':
        var byte = bytes.getUint8(index);
        output.add(byte);
        index += 1;
        break;
      case '?':
        var boolByte = bytes.getUint8(index);
        if (boolByte == 0) {
          output.add(false);
        } else {
          output.add(true);
        }
        index += 1;
        break;
      case 'h':
        var short = bytes.getInt16(index, endian);
        output.add(short);
        index += 2;
        break;
      case 'H':
        var short = bytes.getUint16(index, endian);
        output.add(short);
        index += 2;
        break;
      case 'i':
        var integer = bytes.getInt32(index, endian);
        output.add(integer);
        index += 4;
        break;
      case 'I':
        var integer = bytes.getUint32(index, endian);
        ;
        output.add(integer);
        index += 4;
        break;
      case 'l':
        var long = bytes.getInt64(index, endian);
        output.add(BigInt.from(long).toSigned(64));
        index += 8;
        break;
      case 'L':
        var long = bytes.getUint64(index, endian);
        output.add(BigInt.from(long).toUnsigned(64));
        index += 8;
        break;
      case 'f':
        var float = bytes.getFloat32(index, endian);
        output.add(float);
        index += 4;
        break;
      case 'd':
        var daable = bytes.getFloat64(index, endian);
        output.add(daable);
        index += 8;
        break;
      default:
        throw new FormatException('Format string cannot contain \'$ch\'');
        break;
    }
  }

  return output;
}

Uint8List pack(String format, List data) {
  if (format == null || format == '') {
    throw new ArgumentError('Format string must have a value');
  }

  var length = calculateSize(format);

  int dataIndex = 0;
  ByteData bytes = new ByteData(length);
  int index = 0;

  Endian endian;

  int i = 0;
  var firstChar = format[i];
  if (firstChar == '@' || firstChar == '=') {
    endian = Endian.host;
    i = 1;
  } else if (firstChar == '<') {
    endian = Endian.little;
    i = 1;
  } else if (firstChar == '>' || firstChar == '!') {
    endian = Endian.big;
    i = 1;
  }

  for (; i < format.length; i++) {
    var ch = format[i];
    switch (ch) {
      case 'x':
        index += 1;
        break;
      case 'b':
        int byte = data[dataIndex++];
        byte = byte.clamp(signedByteMin, signedByteMax);
        bytes.setUint8(index, byte);
        index += 1;
        break;
      case 'B':
        int byte = data[dataIndex++];
        byte = byte.clamp(unsignedByteMin, unsignedByteMax);
        bytes.setUint8(index, byte);
        index += 1;
        break;
      case '?':
        bool boolVal = data[dataIndex++];
        if (boolVal) {
          bytes.setUint8(index, 1);
        } else {
          bytes.setUint8(index, 0);
        }
        index += 1;
        break;
      case 'h':
        int short = data[dataIndex++];
        short = short.clamp(unsignedShortMin, unsignedShortMax);
        bytes.setUint16(index, short, endian);
        index += 2;
        break;
      case 'H':
        int short = data[dataIndex++];
        short = short.clamp(signedShortMin, signedShortMax);
        bytes.setInt16(index, short, endian);
        index += 2;
        break;
      case 'i':
        int integer = data[dataIndex++];
        integer = integer.clamp(unsignedIntMin, unsignedIntMax);
        bytes.setInt32(index, integer, endian);
        index += 4;
        break;
      case 'I':
        int integer = data[dataIndex++];
        integer = integer.clamp(signedIntMin, signedIntMax);
        bytes.setUint32(index, integer, endian);
        index += 4;
        break;
      case 'l':
        BigInt long = data[dataIndex++];
        if (long < unsignedLongMin) {
          long = unsignedLongMin;
        } else if (long > unsignedLongMax) {
          long = unsignedLongMax;
        }
        bytes.setUint64(index, long.toSigned(64).toInt(), endian);
        index += 8;
        break;
      case 'L':
        BigInt long = data[dataIndex++];
        if (long < signedLongMin) {
          long = signedLongMin;
        } else if (long > signedLongMax) {
          long = signedLongMax;
        }
        bytes.setUint64(index, long.toSigned(64).toInt(), endian);
        index += 8;
        break;
      case 'f':
        double float = data[dataIndex++];
        bytes.setFloat32(index, float, endian);
        index += 4;
        break;
      case 'd':
        double float = data[dataIndex++];
        bytes.setFloat64(index, float, endian);
        index += 8;
        break;
      default:
        throw new FormatException('Format string cannot contain \'$ch\'');
        break;
    }
  }

  return Uint8List.view(bytes.buffer, bytes.offsetInBytes, bytes.lengthInBytes);
}

int calculateSize(String format) {
  if (format == null || format == '') {
    throw new ArgumentError('Format string must have a value');
  }

  int calculatedSize = 0;
  for (int i = 0; i < format.length; i++) {
    var ch = format[i];
    switch (ch) {
      case '@':
      case '=':
      case '<':
      case '!':
      case '>':
        break;
      case 'x':
        calculatedSize += 1;
        break;
      case 'b':
        calculatedSize += 1;
        break;
      case 'B':
        calculatedSize += 1;
        break;
      case '?':
        calculatedSize += 1;
        break;
      case 'h':
        calculatedSize += 2;
        break;
      case 'H':
        calculatedSize += 2;
        break;
      case 'i':
        calculatedSize += 4;
        break;
      case 'I':
        calculatedSize += 4;
        break;
      case 'l':
        calculatedSize += 8;
        break;
      case 'L':
        calculatedSize += 8;
        break;
      case 'f':
        calculatedSize += 4;
        break;
      case 'd':
        calculatedSize += 8;
        break;
      default:
        throw new FormatException('Format string cannot contain \'$ch\'');
        break;
    }
  }

  return calculatedSize;
}
