import '../exceptions/networking_exception.dart';

class DepartmentRequest {
  final String name;
  final int requiredHosts;

  DepartmentRequest({required this.name, required this.requiredHosts}) {
    _validate();
  }

  void _validate() {
    if (name.trim().isEmpty) {
      throw DepartmentValidationException('Department name cannot be empty');
    }

    if (requiredHosts <= 0) {
      throw DepartmentValidationException(
        'Department "$name" must require at least one host',
      );
    }

    if (requiredHosts > 4294967294) {
      throw DepartmentValidationException(
        'Department "$name" requires too many hosts',
      );
    }
  }

  @override
  String toString() {
    return '$name ($requiredHosts hosts)';
  }
}
