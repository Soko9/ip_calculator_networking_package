import 'package:networking/src/models/ipv4_address.dart';
import 'package:test/test.dart';

void main() {
  group('IPv4Address', () {
    test('creates IPv4 from string', () {
      final ip = IPv4Address.fromString('192.168.1.10');

      expect(ip.toString(), '192.168.1.10');
    });

    test('converts IPv4 to binary', () {
      final ip = IPv4Address.fromString('192.168.1.10');

      expect(ip.toBinaryString(), '11000000.10101000.00000001.00001010');
    });

    test('creates IPv4 from octets', () {
      final ip = IPv4Address.fromOctets(10, 0, 0, 1);

      expect(ip.toString(), '10.0.0.1');
    });

    test('supports addition', () {
      final ip = IPv4Address.fromString('192.168.1.10');

      expect((ip + 1).toString(), '192.168.1.11');
    });

    test('supports bitwise AND', () {
      final ip = IPv4Address.fromString('192.168.1.10');

      final mask = IPv4Address.fromString('255.255.255.0');

      expect((ip & mask).toString(), '192.168.1.0');
    });
  });
}
