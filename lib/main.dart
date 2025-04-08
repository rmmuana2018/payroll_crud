import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_ops/services/api_service.dart';

import 'cubits/auth_cubit.dart';
import 'models/employee.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');

  runApp(MultiBlocProvider(providers: [BlocProvider(create: (_) => AuthCubit(ApiService()))], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Payroll System', debugShowCheckedModeBanner: false, home: const LoginScreen(),);
  }
}
