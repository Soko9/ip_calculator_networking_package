import '../exceptions/networking_exception.dart';
import '../models/index.dart';
import 'subnet_calculator.dart';

class VlsmCalculator {
  final SubnetCalculator _subnetCalculator;

  const VlsmCalculator({this._subnetCalculator = const SubnetCalculator()});

  List<VlsmSubnet> calculate({
    required Subnet parentSubnet,
    required List<DepartmentRequest> departments,
  }) {
    _validateDepartments(departments);

    final sortedDepartments = [...departments]
      ..sort((a, b) => b.requiredHosts.compareTo(a.requiredHosts));

    final results = <VlsmSubnet>[];

    var currentAddress = parentSubnet.networkAddress;

    for (final department in sortedDepartments) {
      if (!_isAddressInsideParent(currentAddress, parentSubnet)) {
        throw VlsmAllocationException(
          'No remaining address space '
          'for department ${department.name}',
        );
      }

      final cidr = _calculateRequiredCidr(department.requiredHosts);

      final subnet = _subnetCalculator.calculate(
        address: currentAddress,
        cidr: cidr,
      );

      if (!_isSubnetInsideParent(subnet, parentSubnet)) {
        throw VlsmAllocationException(
          'Not enough space in '
          '${parentSubnet.notation} '
          'for department '
          '${department.name}',
        );
      }

      results.add(
        VlsmSubnet(
          department: department.name,
          requestedHosts: department.requiredHosts,
          subnet: subnet,
        ),
      );

      if (!_hasNextAddress(subnet.broadcastAddress)) {
        currentAddress = subnet.broadcastAddress;
      } else {
        currentAddress = subnet.broadcastAddress + 1;
      }
    }

    return results;
  }

  void _validateDepartments(List<DepartmentRequest> departments) {
    final names = <String>{};

    for (final department in departments) {
      final normalized = department.name.trim().toLowerCase();

      if (!names.add(normalized)) {
        throw DepartmentValidationException(
          'Duplicate department name: '
          '${department.name}',
        );
      }
    }
  }

  bool _isAddressInsideParent(IPv4Address address, Subnet parent) {
    return address >= parent.networkAddress &&
        address <= parent.broadcastAddress;
  }

  bool _hasNextAddress(IPv4Address address) {
    return address.value < 0xFFFFFFFF;
  }

  bool _isSubnetInsideParent(Subnet subnet, Subnet parent) {
    return subnet.networkAddress >= parent.networkAddress &&
        subnet.broadcastAddress <= parent.broadcastAddress;
  }

  Cidr _calculateRequiredCidr(int hosts) {
    var hostBits = 0;

    while (true) {
      final usableHosts = (1 << hostBits) - 2;

      if (usableHosts >= hosts) {
        break;
      }

      hostBits++;
    }

    return Cidr(32 - hostBits);
  }
}
