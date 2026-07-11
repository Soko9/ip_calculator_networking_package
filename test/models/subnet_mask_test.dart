import 'package:test/test.dart';

import 'package:networking/src/models/index.dart';

void main() {
  group('SubnetMask', () {
    test('creates mask from CIDR', () {
      final mask = SubnetMask.fromCidr(Cidr(24));

      expect(mask.decimal, '255.255.255.0');
    });

    test('/26 creates correct mask', () {
      final mask = SubnetMask.fromCidr(Cidr(26));

      expect(mask.decimal, '255.255.255.192');
    });

    test('calculates wildcard mask', () {
      final mask = SubnetMask.fromCidr(Cidr(26));

      expect(mask.wildcard.toString(), '0.0.0.63');
    });

    test('calculates binary mask', () {
      final mask = SubnetMask.fromCidr(Cidr(24));

      expect(mask.binary, '11111111.11111111.11111111.00000000');
    });

    test('calculates block size', () {
      final mask = SubnetMask.fromCidr(Cidr(26));

      expect(mask.blockSize, 64);
    });

    test('calculates prefix length', () {
      final mask = SubnetMask.fromString('255.255.255.0');

      expect(mask.prefixLength, 24);
    });
  });
}
