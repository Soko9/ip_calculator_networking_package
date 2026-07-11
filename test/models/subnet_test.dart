import 'package:test/test.dart';

import 'package:networking/src/models/index.dart';

void main() {
  group('Subnet', () {
    test('creates subnet notation', () {
      final subnet = Subnet(
        networkAddress: IPv4Address.fromString('192.168.1.0'),
        cidr: Cidr(26),
      );

      expect(subnet.notation, '192.168.1.0/26');
    });

    test('calculates broadcast address', () {
      final subnet = Subnet(
        networkAddress: IPv4Address.fromString('192.168.1.0'),
        cidr: Cidr(26),
      );

      expect(subnet.broadcastAddress.toString(), '192.168.1.63');
    });

    test('calculates first host', () {
      final subnet = Subnet(
        networkAddress: IPv4Address.fromString('192.168.1.0'),
        cidr: Cidr(26),
      );

      expect(subnet.firstHost.toString(), '192.168.1.1');
    });

    test('calculates last host', () {
      final subnet = Subnet(
        networkAddress: IPv4Address.fromString('192.168.1.0'),
        cidr: Cidr(26),
      );

      expect(subnet.lastHost.toString(), '192.168.1.62');
    });

    test('checks if address belongs to subnet', () {
      final subnet = Subnet(
        networkAddress: IPv4Address.fromString('192.168.1.0'),
        cidr: Cidr(26),
      );

      expect(subnet.contains(IPv4Address.fromString('192.168.1.20')), true);

      expect(subnet.contains(IPv4Address.fromString('192.168.1.100')), false);
    });
  });
}
