import 'package:test/test.dart';
import 'package:networking/src/models/cidr.dart';

void main() {
  group('CIDR', () {
    test('creates CIDR', () {
      final cidr = Cidr(24);

      expect(cidr.prefixLength, 24);
      expect(cidr.toString(), '/24');
    });

    test('creates CIDR from string', () {
      final cidr = Cidr.fromString('/26');

      expect(cidr.prefixLength, 26);
    });

    test('calculates host bits', () {
      final cidr = Cidr(24);

      expect(cidr.hostBits, 8);
    });

    test('calculates total addresses', () {
      final cidr = Cidr(26);

      expect(cidr.totalAddresses, 64);
    });

    test('calculates usable hosts', () {
      final cidr = Cidr(26);

      expect(cidr.usableHosts, 62);
    });

    test('/32 has one usable address', () {
      final cidr = Cidr(32);

      expect(cidr.usableHosts, 1);
    });

    test('/31 has two usable addresses', () {
      final cidr = Cidr(31);

      expect(cidr.usableHosts, 2);
    });
  });
}
