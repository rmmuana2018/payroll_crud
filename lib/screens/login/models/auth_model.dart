enum AuthStatus { initial, loading, success, failure }

class AuthModel {
  final AuthStatus status;
  final String? token;
  final String? error;

  const AuthModel({this.status = AuthStatus.initial, this.token, this.error});

  AuthModel copyWith({AuthStatus? status, String? token, String? error}) {
    return AuthModel(status: status ?? this.status, token: token ?? this.token, error: error ?? this.error);
  }
}
