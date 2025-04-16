import 'package:hive/hive.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
class EmployeeModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double hourlyRate;

  EmployeeModel({required this.name, required this.hourlyRate});
}
