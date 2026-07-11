class NetworkingException implements Exception {
  final String message;

  const NetworkingException(this.message);

  @override
  String toString() {
    return message;
  }
}

class VlsmAllocationException extends NetworkingException {
  const VlsmAllocationException(super.message);
}

class DepartmentValidationException extends NetworkingException {
  const DepartmentValidationException(super.message);
}
