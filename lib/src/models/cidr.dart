class Cidr {
  final int prefixLength;

  const Cidr(this.prefixLength)
    : assert(
        prefixLength >= 0 && prefixLength <= 32,
        'CIDR prefix must be between 0 and 32',
      );

  factory Cidr.fromString(String value) {
    if (!value.startsWith('/')) {
      throw FormatException('CIDR must start with /');
    }

    final prefix = int.tryParse(value.substring(1));

    if (prefix == null) {
      throw FormatException('Invalid CIDR value: $value');
    }

    return Cidr(prefix);
  }

  /// Number of bits used for the network part
  int get networkBits => prefixLength;

  /// Number of bits used for hosts
  int get hostBits => 32 - prefixLength;

  /// Total number of addresses in this subnet
  int get totalAddresses {
    return 1 << hostBits;
  }

  /// Number of usable addresses
  ///
  /// /31 and /32 are special cases:
  /// /31 is used for point-to-point links
  /// /32 represents a single host
  int get usableHosts {
    if (prefixLength == 32) {
      return 1;
    }

    if (prefixLength == 31) {
      return 2;
    }

    return totalAddresses - 2;
  }

  /// Converts:
  ///
  /// Cidr(24)
  ///
  /// to:
  ///
  /// /24
  @override
  String toString() {
    return '/$prefixLength';
  }

  @override
  bool operator ==(Object other) {
    return other is Cidr && other.prefixLength == prefixLength;
  }

  @override
  int get hashCode => prefixLength.hashCode;
}
