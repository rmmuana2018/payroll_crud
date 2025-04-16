import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../models/employee_model.dart';
import '../../../db_services/employee_database.dart';
import '../../login/controllers/auth_notifier.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  TextEditingController searchController = TextEditingController();
  List<EmployeeModel> employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _loadEmployees({String query = ""}) {
    final data = EmployeeDatabase.getEmployees(query: query);
    setState(() => employees = data);
  }

  void _logout() async {
    var box = Hive.box('authBox');
    await box.delete('authToken');
    await box.delete('employee_id');
    await box.delete('user_logged');
    if (mounted) context.go('/login');
  }

  void _showEmployeeDialog(BuildContext context, {EmployeeModel? employee}) {
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
                if (employee == null) {
                  final newEmployee = EmployeeModel(name: nameController.text, hourlyRate: double.tryParse(rateController.text) ?? 0.0);
                  await EmployeeDatabase.insertEmployee(newEmployee);
                } else {
                  employee.name = nameController.text;
                  employee.hourlyRate = double.tryParse(rateController.text) ?? 0.0;
                  await EmployeeDatabase.updateEmployee(employee);
                }
                _loadEmployees();
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(employee == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _deleteEmployee(BuildContext context, EmployeeModel employee) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete ${employee.name} employee?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await employee.delete();
              _loadEmployees();
              if (context.mounted) Navigator.pop(context);
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
        title: const Text('Employees', style: TextStyle(color: Color(0xffffffff))),
        backgroundColor: const Color(0xFFFF9000),
        // actions: [IconButton(icon: const Icon(Icons.logout, color: Color(0xffffffff)), onPressed: () => _logout())],
        actions: [
          PopupMenuButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: Text(ref.read(authNotifierProvider.notifier).getEmployeeId(), style: const TextStyle(color: Colors.white, fontSize: 16))),
            ),
            itemBuilder:
                (context) => <PopupMenuEntry<String>>[
              PopupMenuItem(enabled: false, child: Text(ref.read(authNotifierProvider.notifier).getUserLogged())),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(children: const [Icon(Icons.logout, color: Colors.red), SizedBox(width: 8), Text("Logout")]),
              ),
            ],
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
          ),
        ],
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
                      IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteEmployee(context, employee)),
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