enum AuthStatus { initial, loading, success, failure }

class AuthState {
  final AuthStatus status;
  final String? token;
  final String? error;

  const AuthState({this.status = AuthStatus.initial, this.token, this.error});

  AuthState copyWith({AuthStatus? status, String? token, String? error}) {
    return AuthState(status: status ?? this.status, token: token ?? this.token, error: error ?? this.error);
  }
}
