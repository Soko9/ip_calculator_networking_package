import 'package:test/test.dart';

import 'package:networking/src/models/index.dart';

void main() {
  test('returns complete subnet information', () {
    final subnet = Subnet(
      networkAddress: IPv4Address.fromString('192.168.0.0'),
      cidr: Cidr(26),
    );

    final result = VlsmSubnet(
      department: 'IT',
      requestedHosts: 50,
      subnet: subnet,
    );

    expect(result.network.decimal, '192.168.0.0');

    expect(result.broadcast.decimal, '192.168.0.63');

    expect(result.firstHost.decimal, '192.168.0.1');

    expect(result.lastHost.decimal, '192.168.0.62');

    expect(result.usableHosts, 62);

    expect(result.unusedHosts, 12);
  });
}
