import 'ipv4_address.dart';
import 'cidr.dart';

class SubnetMask {
  final IPv4Address address;

  const SubnetMask(this.address);

  factory SubnetMask.fromCidr(Cidr cidr) {
    final maskValue = cidr.prefixLength == 0
        ? 0
        : (0xFFFFFFFF << (32 - cidr.prefixLength)) & 0xFFFFFFFF;

    return SubnetMask(IPv4Address(maskValue));
  }

  factory SubnetMask.fromString(String value) {
    return SubnetMask(IPv4Address.fromString(value));
  }

  /// The mask as a normal IPv4 string
  String get decimal => address.toString();

  /// Binary representation
  String get binary => address.toBinaryString();

  /// CIDR prefix length
  int get prefixLength {
    var bits = address.value;
    var count = 0;

    while (bits != 0) {
      count += bits & 1;
      bits >>= 1;
    }

    return count;
  }

  /// Wildcard mask
  ///
  /// Example:
  /// 255.255.255.192
  ///
  /// becomes:
  /// 0.0.0.63
  IPv4Address get wildcard {
    return IPv4Address((~address.value) & 0xFFFFFFFF);
  }

  /// Binary wildcard mask
  String get wildcardBinary {
    return wildcard.toBinaryString();
  }

  /// Number of addresses inside this subnet
  int get blockSize {
    return 1 << (32 - prefixLength);
  }

  @override
  String toString() {
    return address.toString();
  }

  @override
  bool operator ==(Object other) {
    return other is SubnetMask && other.address == address;
  }

  @override
  int get hashCode => address.hashCode;
}
