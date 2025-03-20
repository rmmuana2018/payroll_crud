import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/employee.dart';

class EmployeeDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'employees.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE employees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, hourlyRate REAL)");
      },
    );
  }

  static Future<void> insertEmployee(Employee employee) async {
    final db = await database;
    await db.insert('employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Employee>> getEmployees({String query = ""}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'employees',
      where: query.isNotEmpty ? 'name LIKE ?' : null,
      whereArgs: query.isNotEmpty ? ['%$query%'] : null,
    );
    return List.generate(maps.length, (i) {
      return Employee(id: maps[i]['id'], name: maps[i]['name'], hourlyRate: maps[i]['hourlyRate']);
    });
  }

  static Future<void> updateEmployee(Employee employee) async {
    final db = await database;
    await db.update('employees', employee.toMap(), where: 'id = ?', whereArgs: [employee.id]);
  }

  static Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}
