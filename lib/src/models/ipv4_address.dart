class IPv4Address implements Comparable<IPv4Address> {
  final int value;

  const IPv4Address(this.value)
    : assert(
        value >= 0 && value <= 0xFFFFFFFF,
        'IPv4 value must be between 0 and 4294967295',
      );

  factory IPv4Address.fromString(String address) {
    final parts = address.split('.');

    if (parts.length != 4) {
      throw FormatException('Invalid IPv4 address: $address');
    }

    final octets = parts.map((part) {
      final value = int.tryParse(part);

      if (value == null || value < 0 || value > 255) {
        throw FormatException('Invalid IPv4 address: $address');
      }

      return value;
    }).toList();

    return IPv4Address.fromOctets(octets[0], octets[1], octets[2], octets[3]);
  }

  factory IPv4Address.fromOctets(int first, int second, int third, int fourth) {
    final octets = [first, second, third, fourth];

    for (final octet in octets) {
      if (octet < 0 || octet > 255) {
        throw FormatException('IPv4 octet must be between 0 and 255');
      }
    }

    final value = (first << 24) | (second << 16) | (third << 8) | fourth;

    return IPv4Address(value);
  }

  bool get isValid {
    return value >= 0 && value <= 0xFFFFFFFF;
  }

  List<int> get octets {
    return [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }

  String toBinaryString() {
    return octets
        .map((octet) => octet.toRadixString(2).padLeft(8, '0'))
        .join('.');
  }

  @override
  String toString() {
    return octets.join('.');
  }

  IPv4Address operator +(int amount) {
    final newValue = value + amount;

    if (newValue > 0xFFFFFFFF) {
      throw RangeError('IPv4 address overflow');
    }

    return IPv4Address(newValue);
  }

  IPv4Address operator -(int amount) {
    final newValue = value - amount;

    if (newValue < 0) {
      throw RangeError('IPv4 address underflow');
    }

    return IPv4Address(newValue);
  }

  IPv4Address operator &(IPv4Address other) {
    return IPv4Address(value & other.value);
  }

  IPv4Address operator |(IPv4Address other) {
    return IPv4Address(value | other.value);
  }

  @override
  int compareTo(IPv4Address other) {
    return value.compareTo(other.value);
  }

  @override
  bool operator ==(Object other) {
    return other is IPv4Address && other.value == value;
  }

  bool operator <(IPv4Address other) {
    return value < other.value;
  }

  bool operator <=(IPv4Address other) {
    return value <= other.value;
  }

  bool operator >(IPv4Address other) {
    return value > other.value;
  }

  bool operator >=(IPv4Address other) {
    return value >= other.value;
  }

  @override
  int get hashCode => value.hashCode;
}
