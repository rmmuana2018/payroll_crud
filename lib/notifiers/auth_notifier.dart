import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api_services/auth_api.dart';
import '../states/auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.initial);
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await AuthApi().login(email, password);
      var box = Hive.box('authBox');
      await box.put('authToken', response['token']);
      await box.put('employee_id', response['employee_id']);
      await box.put('user_logged', response['user_logged']);
      state = state.copyWith(status: AuthStatus.success, token: response['token']);
    } catch (e) {
      state = state.copyWith(status: AuthStatus.failure, error: e.toString());
    }
  }

  String getEmployeeId(){
    var box = Hive.box('authBox');
    return box.get('employee_id')?.toString() ?? '';
  }

  String getUserLogged(){
    var box = Hive.box('authBox');
    return box.get('user_logged')?.toString() ?? 'User';
  }
}