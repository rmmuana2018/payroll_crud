import 'package:hive_flutter/hive_flutter.dart';
import '../models/employee.dart';

class EmployeeDatabase {
  static final _employeeBox = Hive.box<Employee>('employees');

  static List<Employee> getEmployees({String query = ""}) {
    final allEmployees = _employeeBox.values.toList();
    if (query.isEmpty) return allEmployees;
    return allEmployees.where((e)=>e.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Future<void> insertEmployee(Employee employee) async {
    await _employeeBox.add(employee);
  }

  static Future<void> updateEmployee(Employee employee) async {
    await employee.save();
  }

  static Future<void> deleteEmployee(Employee employee) async {
    await employee.delete();
  }

  static Future<void> clearAll() async {
    await _employeeBox.clear();
  }
}
