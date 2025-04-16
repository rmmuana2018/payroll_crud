import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'screens/login/views/login_screen.dart';
import 'screens/dashboard/views/dashboard_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  refreshListenable: AuthChangeNotifier(),
  redirect: (context, state) {
    final bool loggedIn = Hive.box('authBox').containsKey('authToken');
    final bool loggingIn = state.uri.path == '/login';
    if (!loggedIn) return loggingIn ? null : '/login';
    if (loggingIn) return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);

/// [AuthChangeNotifier] is a simple ChangeNotifier that notifies the router when auth status changes.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier() {
    Hive.box('authBox').listenable().addListener(notifyListeners);
  }
}