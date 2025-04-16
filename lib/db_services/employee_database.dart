import 'package:hive_flutter/hive_flutter.dart';
import '../screens/dashboard/models/employee_model.dart';

class EmployeeDatabase {
  static final _employeeBox = Hive.box<EmployeeModel>('employees');

  static List<EmployeeModel> getEmployees({String query = ""}) {
    final allEmployees = _employeeBox.values.toList();
    if (query.isEmpty) return allEmployees;
    return allEmployees.where((e)=>e.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Future<void> insertEmployee(EmployeeModel employee) async {
    await _employeeBox.add(employee);
  }

  static Future<void> updateEmployee(EmployeeModel employee) async {
    await employee.save();
  }

  static Future<void> deleteEmployee(EmployeeModel employee) async {
    await employee.delete();
  }

  static Future<void> clearAll() async {
    await _employeeBox.clear();
  }
}
