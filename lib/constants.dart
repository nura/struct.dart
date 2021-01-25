library constants;

const int signedByteMin = -128;
const int signedByteMax = 127;

const int unsignedByteMin = 0;
const int unsignedByteMax = 255;

const int signedShortMin = -32768;
const int signedShortMax = 32767;

const int unsignedShortMin = 0;
const int unsignedShortMax = 65535;

const int signedIntMin = -2147483648;
const int signedIntMax = 2147483647;

const int unsignedIntMin = 0;
const int unsignedIntMax = 4294967295;

BigInt signedLongMin = BigInt.from(-9223372036854775808);
BigInt signedLongMax = BigInt.from(9223372036854775807);

BigInt unsignedLongMin = BigInt.from(0);
BigInt unsignedLongMax = BigInt.parse('18446744073709551615');
