import 'package:test/test.dart';

import 'package:networking/src/models/index.dart';
import 'package:networking/src/exceptions/networking_exception.dart';

void main() {
  test('rejects empty department name', () {
    expect(
      () => DepartmentRequest(name: '', requiredHosts: 10),

      throwsA(isA<DepartmentValidationException>()),
    );
  });

  test('rejects zero hosts', () {
    expect(
      () => DepartmentRequest(name: 'IT', requiredHosts: 0),

      throwsA(isA<DepartmentValidationException>()),
    );
  });

  test('accepts valid department', () {
    final department = DepartmentRequest(name: 'IT', requiredHosts: 50);

    expect(department.requiredHosts, 50);
  });
}
