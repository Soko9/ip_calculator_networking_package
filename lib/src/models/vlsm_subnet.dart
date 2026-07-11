import 'subnet.dart';
import 'ip_representation.dart';

class VlsmSubnet {
  final String department;

  final int requestedHosts;

  final Subnet subnet;

  const VlsmSubnet({
    required this.department,
    required this.requestedHosts,
    required this.subnet,
  });

  //
  // Address information
  //

  IpRepresentation get network {
    return IpRepresentation(subnet.networkAddress);
  }

  IpRepresentation get firstHost {
    return IpRepresentation(subnet.firstHost);
  }

  IpRepresentation get lastHost {
    return IpRepresentation(subnet.lastHost);
  }

  IpRepresentation get broadcast {
    return IpRepresentation(subnet.broadcastAddress);
  }

  IpRepresentation get subnetMask {
    return IpRepresentation(subnet.subnetMask.address);
  }

  IpRepresentation get wildcardMask {
    return IpRepresentation(subnet.wildcardMask);
  }

  //
  // CIDR information
  //

  String get cidr {
    return subnet.cidr.toString();
  }

  int get prefixLength {
    return subnet.cidr.prefixLength;
  }

  //
  // Capacity information
  //

  int get totalAddresses {
    return subnet.totalAddresses;
  }

  int get usableHosts {
    return subnet.usableHosts;
  }

  int get unusedHosts {
    return usableHosts - requestedHosts;
  }

  int get blockSize {
    return subnet.subnetMask.blockSize;
  }

  @override
  String toString() {
    return '''
  Department:
  $department


  Network:
  $network


  Subnet Mask:
  $subnetMask


  Wildcard Mask:
  $wildcardMask


  First Host:
  $firstHost


  Last Host:
  $lastHost


  Broadcast:
  $broadcast


  CIDR:
  $cidr


  Requested Hosts:
  $requestedHosts


  Usable Hosts:
  $usableHosts


  Unused Hosts:
  $unusedHosts
  ''';
  }
}
