import 'package:flutter/material.dart';

import '../models/employee.dart';
import '../services/db_service.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController searchController = TextEditingController();
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees({String query = ""}) async {
    final data = await EmployeeDatabase.getEmployees(query: query);
    setState(() => employees = data);
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  void _showEmployeeDialog(BuildContext context, {Employee? employee}) {
    final nameController = TextEditingController(text: employee?.name);
    final rateController = TextEditingController(text: employee?.hourlyRate.toString());
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
                TextField(controller: rateController, decoration: InputDecoration(labelText: 'Hourly Rate'), keyboardType: TextInputType.number),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty && rateController.text.isNotEmpty) {
                    final newEmployee = Employee(
                      id: employee?.id,
                      name: nameController.text,
                      hourlyRate: double.tryParse(rateController.text) ?? 0.0,
                    );
                    employee == null ? await EmployeeDatabase.insertEmployee(newEmployee) : await EmployeeDatabase.updateEmployee(newEmployee);
                    _loadEmployees();
                  }
                  Navigator.pop(context);
                },
                child: Text(employee == null ? 'Add' : 'Update'),
              ),
            ],
          ),
    );
  }

  void _deleteEmployee(BuildContext context, int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text("Are you sure you want to delete this employee?"),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
              TextButton(
                onPressed: () async {
                  await EmployeeDatabase.deleteEmployee(id);
                  _loadEmployees();
                  Navigator.pop(context);
                },
                child: const Text("Delete", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Employees', style: TextStyle(color: Color(0xffffffff))),
        backgroundColor: Color(0xFFFF9000),
        actions: [IconButton(icon: const Icon(Icons.logout, color: Color(0xffffffff)), onPressed: () => _logout(context))],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Search Employee', prefixIcon: Icon(Icons.search)),
              onChanged: (query) => _loadEmployees(query: query),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: employees.length,
              itemBuilder: (context, index) {
                final employee = employees[index];
                return ListTile(
                  title: Text(employee.name),
                  subtitle: Text('Hourly Rate: Php${employee.hourlyRate.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEmployeeDialog(context, employee: employee)),
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteEmployee(context, employee.id!)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEmployeeDialog(context),
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Color(0xffffffff)),
      ),
    );
  }
}
