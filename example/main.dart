import 'package:networking/networking.dart';

void main() {
  // --------------------------------------------------
  // 1. Create a parent network
  // --------------------------------------------------

  final parentNetwork = SubnetCalculator().calculateFromString(
    address: '192.168.0.0',
    prefixLength: 24,
  );

  print('==============================');
  print('PARENT NETWORK');
  print('==============================');

  print(
    'Network: '
    '${parentNetwork.networkAddress}',
  );

  print(
    'CIDR: '
    '${parentNetwork.cidr}',
  );

  print(
    'Mask: '
    '${parentNetwork.subnetMask}',
  );

  print(
    'Broadcast: '
    '${parentNetwork.broadcastAddress}',
  );

  print(
    'First Host: '
    '${parentNetwork.firstHost}',
  );

  print(
    'Last Host: '
    '${parentNetwork.lastHost}',
  );

  print(
    'Usable Hosts: '
    '${parentNetwork.usableHosts}',
  );

  // --------------------------------------------------
  // 2. Create departments
  // --------------------------------------------------

  final departments = [
    DepartmentRequest(name: 'Guests', requiredHosts: 100),

    DepartmentRequest(name: 'IT', requiredHosts: 50),

    DepartmentRequest(name: 'HR', requiredHosts: 30),

    DepartmentRequest(name: 'Sales', requiredHosts: 12),
  ];

  // --------------------------------------------------
  // 3. Run VLSM calculation
  // --------------------------------------------------

  final vlsmResults = VlsmCalculator().calculate(
    parentSubnet: parentNetwork,
    departments: departments,
  );

  print('\n==============================');
  print('VLSM RESULTS');
  print('==============================');

  for (final result in vlsmResults) {
    print('\n--------------------------------');
    print(
      'Department: '
      '${result.department}',
    );

    print(
      'CIDR: '
      '${result.cidr}',
    );

    print('\nNetwork');

    print(
      'Decimal: '
      '${result.network.decimal}',
    );

    print(
      'Binary: '
      '${result.network.binary}',
    );

    print('\nSubnet Mask');

    print(
      'Decimal: '
      '${result.subnetMask.decimal}',
    );

    print(
      'Binary: '
      '${result.subnetMask.binary}',
    );

    print('\nWildcard');

    print(
      'Decimal: '
      '${result.wildcardMask.decimal}',
    );

    print(
      'Binary: '
      '${result.wildcardMask.binary}',
    );

    print('\nFirst Host');

    print(
      'Decimal: '
      '${result.firstHost.decimal}',
    );

    print(
      'Binary: '
      '${result.firstHost.binary}',
    );

    print('\nLast Host');

    print(
      'Decimal: '
      '${result.lastHost.decimal}',
    );

    print(
      'Binary: '
      '${result.lastHost.binary}',
    );

    print('\nBroadcast');

    print(
      'Decimal: '
      '${result.broadcast.decimal}',
    );

    print(
      'Binary: '
      '${result.broadcast.binary}',
    );

    print('\nCapacity');

    print(
      'Requested Hosts: '
      '${result.requestedHosts}',
    );

    print(
      'Usable Hosts: '
      '${result.usableHosts}',
    );

    print(
      'Unused Hosts: '
      '${result.unusedHosts}',
    );

    print(
      'Block Size: '
      '${result.blockSize}',
    );
  }
}
