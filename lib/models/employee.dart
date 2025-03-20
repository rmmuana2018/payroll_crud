class Employee {
  int? id;
  String name;
  double hourlyRate;

  Employee({this.id, required this.name, required this.hourlyRate});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'hourlyRate': hourlyRate};
  }
}