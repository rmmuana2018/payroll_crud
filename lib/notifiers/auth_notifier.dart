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
      state = state.copyWith(
        status: AuthStatus.success,
        token: response['token'],
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.failure,
        error: e.toString(),
      );
    }
  }
}
