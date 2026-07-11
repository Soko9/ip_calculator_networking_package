import 'ipv4_address.dart';

class IpRepresentation {
  final IPv4Address address;

  const IpRepresentation(this.address);

  String get decimal {
    return address.toString();
  }

  String get binary {
    return address.toBinaryString();
  }

  @override
  String toString() {
    return '''
Decimal:
$decimal

Binary:
$binary
''';
  }
}
