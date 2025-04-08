import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_service.dart';

part 'auth_notifier.g.dart';

/// Define your auth states.
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String token;
  AuthSuccess(this.token);
}

class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => AuthInitial();

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final response = await AuthApi().login(email, password);
      state = AuthSuccess(response['token']);
    } catch (e) {
      state = AuthFailure(e.toString());
    }
  }
}
