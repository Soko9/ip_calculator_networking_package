import 'package:test/test.dart';

import 'package:networking/src/calculators/index.dart';
import 'package:networking/src/models/index.dart';

void main() {
  group('SubnetCalculator', () {
    test('calculates /24 subnet', () {
      final calculator = SubnetCalculator();

      final subnet = calculator.calculate(
        address: IPv4Address.fromString('192.168.1.50'),

        cidr: Cidr(24),
      );

      expect(subnet.networkAddress.toString(), '192.168.1.0');

      expect(subnet.broadcastAddress.toString(), '192.168.1.255');

      expect(subnet.firstHost.toString(), '192.168.1.1');

      expect(subnet.lastHost.toString(), '192.168.1.254');
    });

    test('calculates /26 subnet', () {
      final calculator = SubnetCalculator();

      final subnet = calculator.calculate(
        address: IPv4Address.fromString('192.168.1.50'),

        cidr: Cidr(26),
      );

      expect(subnet.networkAddress.toString(), '192.168.1.0');

      expect(subnet.broadcastAddress.toString(), '192.168.1.63');

      expect(subnet.usableHosts, 62);
    });

    test('works with string input', () {
      final calculator = SubnetCalculator();

      final subnet = calculator.calculateFromString(
        address: '10.0.0.20',

        prefixLength: 8,
      );

      expect(subnet.networkAddress.toString(), '10.0.0.0');
    });
  });
}
