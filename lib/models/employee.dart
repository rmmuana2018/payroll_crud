import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double hourlyRate;

  Employee({required this.name, required this.hourlyRate});
}
