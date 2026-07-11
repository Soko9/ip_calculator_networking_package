import 'ipv4_address.dart';
import 'cidr.dart';
import 'subnet_mask.dart';

class Subnet {
  final IPv4Address networkAddress;
  final Cidr cidr;

  const Subnet({required this.networkAddress, required this.cidr});

  SubnetMask get subnetMask {
    return SubnetMask.fromCidr(cidr);
  }

  IPv4Address get wildcardMask {
    return subnetMask.wildcard;
  }

  IPv4Address get broadcastAddress {
    return IPv4Address(networkAddress.value | wildcardMask.value);
  }

  IPv4Address get firstHost {
    if (cidr.prefixLength >= 31) {
      return networkAddress;
    }

    return networkAddress + 1;
  }

  IPv4Address get lastHost {
    if (cidr.prefixLength >= 31) {
      return broadcastAddress;
    }

    return broadcastAddress - 1;
  }

  int get totalAddresses {
    return cidr.totalAddresses;
  }

  int get usableHosts {
    return cidr.usableHosts;
  }

  String get notation {
    return '${networkAddress.toString()}${cidr.toString()}';
  }

  bool contains(IPv4Address address) {
    final network = address & subnetMask.address;

    return network == networkAddress;
  }

  @override
  String toString() {
    return notation;
  }

  @override
  bool operator ==(Object other) {
    return other is Subnet &&
        other.networkAddress == networkAddress &&
        other.cidr == cidr;
  }

  @override
  int get hashCode {
    return Object.hash(networkAddress, cidr);
  }
}
