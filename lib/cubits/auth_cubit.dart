import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';

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

class AuthCubit extends Cubit<AuthState> {
  final ApiService apiService;

  AuthCubit(this.apiService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await apiService.login(email, password);
      emit(AuthSuccess(response['token']));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}