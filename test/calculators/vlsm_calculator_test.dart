import 'package:networking/src/exceptions/networking_exception.dart';
import 'package:test/test.dart';

import 'package:networking/src/calculators/vlsm_calculator.dart';
import 'package:networking/src/models/index.dart';

void main() {
  test('allocates VLSM subnets correctly', () {
    final parentSubnet = Subnet(
      networkAddress: IPv4Address.fromString('192.168.0.0'),

      cidr: Cidr(24),
    );

    final departments = [
      DepartmentRequest(name: 'Guests', requiredHosts: 100),

      DepartmentRequest(name: 'IT', requiredHosts: 50),

      DepartmentRequest(name: 'HR', requiredHosts: 30),
    ];

    final result = VlsmCalculator().calculate(
      parentSubnet: parentSubnet,

      departments: departments,
    );

    expect(result[0].subnet.notation, '192.168.0.0/25');

    expect(result[1].subnet.notation, '192.168.0.128/26');

    expect(result[2].subnet.notation, '192.168.0.192/27');
  });

  test('throws when parent subnet has no remaining space', () {
    final parent = Subnet(
      networkAddress: IPv4Address.fromString('192.168.1.252'),
      cidr: Cidr(30),
    );

    final departments = [
      DepartmentRequest(name: 'Router Link', requiredHosts: 2),

      DepartmentRequest(name: 'Extra Network', requiredHosts: 2),
    ];

    expect(
      () => VlsmCalculator().calculate(
        parentSubnet: parent,
        departments: departments,
      ),

      throwsA(isA<VlsmAllocationException>()),
    );
  });

  test('rejects duplicate department names', () {
    final parent = Subnet(
      networkAddress: IPv4Address.fromString('192.168.0.0'),
      cidr: Cidr(24),
    );

    expect(
      () => VlsmCalculator().calculate(
        parentSubnet: parent,
        departments: [
          DepartmentRequest(name: 'IT', requiredHosts: 20),

          DepartmentRequest(name: 'it', requiredHosts: 10),
        ],
      ),

      throwsA(isA<DepartmentValidationException>()),
    );
  });
}
