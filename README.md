# networking

A pure Dart library for IPv4 subnet calculations and Variable Length Subnet Masking (VLSM). Perform subnet analysis, CIDR operations, and automatic department-based address allocation with zero external dependencies.

## Features

- **IPv4 Address** -- Parse, construct, compare, and perform bitwise operations on IPv4 addresses.
- **CIDR Notation** -- Convert between prefix lengths, determine host/network bit counts, and calculate address capacities.
- **Subnet Mask** -- Derive masks from CIDR, compute wildcard masks, block sizes, and binary representations.
- **Subnet Calculator** -- Compute network address, broadcast address, first/last host, usable hosts, and full CIDR notation for any IPv4 network.
- **VLSM Calculator** -- Automatically allocate optimally-sized subnets for multiple departments or groups within a parent network, sorted largest-first.
- **Rich Representations** -- Every model provides both decimal and binary string outputs via `IpRepresentation`.

## Getting started

### Prerequisites

- Dart SDK `^3.12.2`

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  networking: ^1.0.0
```

Then run:

```sh
dart pub get
```

## Usage

### Import the package

```dart
import 'package:networking/networking.dart';
```

---

### Creating an IPv4 address

```dart
// From a dotted-decimal string
final address = IPv4Address.fromString('192.168.1.10');

// From individual octets
final same = IPv4Address.fromOctets(192, 168, 1, 10);

// Access octets, binary representation, and more
print(address.octets);        // [192, 168, 1, 10]
print(address.toBinaryString()); // 11000000.10101000.00000001.00001010

// Arithmetic and bitwise operations
final next = address + 1;     // 192.168.1.11
final prev = address - 1;     // 192.168.1.9
final result = address | IPv4Address.fromString('0.0.0.15'); // bitwise OR
```

---

### Working with CIDR

```dart
// Create from a prefix length
final cidr = Cidr(24);

// Parse from a string
final parsed = Cidr.fromString('/26');

print(parsed.hostBits);       // 6
print(parsed.networkBits);   // 26
print(parsed.usableHosts);   // 62
print(parsed.totalAddresses); // 64
```

---

### Subnet mask operations

```dart
final mask = SubnetMask.fromCidr(Cidr(26));

print(mask.decimal);          // 255.255.255.192
print(mask.binary);           // 11111111.11111111.11111111.11000000
print(mask.wildcard);         // 0.0.0.63
print(mask.blockSize);        // 64
```

---

### Subnet calculator

```dart
final calculator = SubnetCalculator();

// Using string input
final subnet = calculator.calculateFromString(
  address: '192.168.0.0',
  prefixLength: 24,
);

print(subnet.networkAddress);  // 192.168.0.0
print(subnet.broadcastAddress); // 192.168.0.255
print(subnet.firstHost);       // 192.168.0.1
print(subnet.lastHost);        // 192.168.0.254
print(subnet.usableHosts);     // 254
print(subnet.notation);        // 192.168.0.0/24

// Using typed objects
final same = calculator.calculate(
  address: IPv4Address.fromOctets(192, 168, 0, 0),
  cidr: Cidr(24),
);
```

---

### VLSM calculator

The VLSM calculator automatically divides a parent network into optimally-sized subnets based on the number of hosts each department requires. Subnets are allocated largest-first to minimize wasted addresses.

```dart
// Define the parent network
final parent = SubnetCalculator().calculateFromString(
  address: '192.168.0.0',
  prefixLength: 24,
);

// Define department requirements
final departments = [
  DepartmentRequest(name: 'Guests',   requiredHosts: 100),
  DepartmentRequest(name: 'IT',       requiredHosts: 50),
  DepartmentRequest(name: 'HR',       requiredHosts: 30),
  DepartmentRequest(name: 'Sales',    requiredHosts: 12),
];

// Calculate allocations
final results = VlsmCalculator().calculate(
  parentSubnet: parent,
  departments: departments,
);

for (final result in results) {
  print('${result.department} (${result.cidr})');
  print('  Network:   ${result.network.decimal}');
  print('  Mask:      ${result.subnetMask.decimal}');
  print('  Wildcard:  ${result.wildcardMask.decimal}');
  print('  First:     ${result.firstHost.decimal}');
  print('  Last:      ${result.lastHost.decimal}');
  print('  Broadcast: ${result.broadcast.decimal}');
  print('  Usable:    ${result.usableHosts}  '
        '(requested ${result.requestedHosts}, '
        'unused ${result.unusedHosts})');
}
```

#### Example output

```
Guests (/26)
  Network:   192.168.0.0
  Mask:      255.255.255.192
  Wildcard:  0.0.0.63
  First:     192.168.0.1
  Last:      192.168.0.62
  Broadcast: 192.168.0.63
  Usable:    62  (requested 100, unused -38)

IT (/26)
  Network:   192.168.0.64
  Mask:      255.255.255.192
  ...
```

> **Note:** If a department requires more hosts than a single subnet can hold, the calculator still allocates the smallest power-of-two block that fits. The `unusedHosts` value may be negative if the requested count exceeds the usable capacity -- this is by design and indicates the department needs a larger parent network.

---

### Checking address membership

```dart
final subnet = SubnetCalculator().calculateFromString(
  address: '10.0.0.0',
  prefixLength: 8,
);

final inside = IPv4Address.fromString('10.50.100.200');
final outside = IPv4Address.fromString('192.168.1.1');

print(subnet.contains(inside));  // true
print(subnet.contains(outside)); // false
```

---

### Binary and decimal representations

```dart
final ip = IPv4Address.fromString('255.255.255.0');
final repr = IpRepresentation(ip);

print(repr.decimal); // 255.255.255.0
print(repr.binary);  // 11111111.11111111.11111111.00000000
```

---

## API reference

| Class                    | Description                                                             |
| ------------------------ | ----------------------------------------------------------------------- |
| `IPv4Address`            | Immutable IPv4 address with arithmetic, bitwise, and comparison ops.    |
| `Cidr`                   | CIDR prefix length with host/network bit counts and capacity helpers.   |
| `SubnetMask`             | Subnet mask derived from CIDR or string, with wildcard and block size.  |
| `Subnet`                 | Full subnet info: network, broadcast, hosts, and membership testing.    |
| `IpRepresentation`       | Wrapper providing decimal and binary string views of an address.        |
| `DepartmentRequest`      | Input model for VLSM: a department name and required host count.        |
| `VlsmSubnet`             | VLSM output: subnet details plus requested/usable/unused host counts.   |
| `SubnetCalculator`       | Computes a `Subnet` from an address and CIDR.                           |
| `VlsmCalculator`         | Allocates multiple subnets within a parent using VLSM.                  |
| `NetworkingException`    | Base exception for networking errors.                                   |
| `VlsmAllocationException`| Thrown when VLSM cannot fit a department in the remaining space.        |
| `DepartmentValidationException` | Thrown for invalid department names or host counts.              |

## Exceptions

All exceptions extend `NetworkingException`:

```dart
try {
  final results = VlsmCalculator().calculate(
    parentSubnet: parent,
    departments: departments,
  );
} on VlsmAllocationException catch (e) {
  print('Allocation failed: $e');
} on DepartmentValidationException catch (e) {
  print('Invalid input: $e');
}
```

| Exception                         | When it is thrown                                           |
| --------------------------------- | ----------------------------------------------------------- |
| `DepartmentValidationException`   | Empty department name, zero/negative hosts, or duplicate names. |
| `VlsmAllocationException`         | Remaining address space is insufficient for a department.   |
| `FormatException`                 | Malformed IPv4 string or invalid CIDR notation.             |

## Additional information

- **Pure Dart** -- no platform dependencies, works everywhere Dart runs (CLI, server, Flutter).
- **Tested** -- unit tests cover models, calculators, and edge cases. Run them with `dart test`.
- **Contributions** -- issues and pull requests are welcome.
