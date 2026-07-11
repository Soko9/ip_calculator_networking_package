import '../models/index.dart';

class SubnetCalculator {
  const SubnetCalculator();

  Subnet calculate({required IPv4Address address, required Cidr cidr}) {
    final mask = cidr.prefixLength == 0
        ? 0
        : (0xFFFFFFFF << (32 - cidr.prefixLength)) & 0xFFFFFFFF;

    final networkValue = address.value & mask;

    return Subnet(networkAddress: IPv4Address(networkValue), cidr: cidr);
  }

  Subnet calculateFromString({
    required String address,
    required int prefixLength,
  }) {
    return calculate(
      address: IPv4Address.fromString(address),

      cidr: Cidr(prefixLength),
    );
  }
}
