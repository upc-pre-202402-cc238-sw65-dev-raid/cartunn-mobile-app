import 'package:cartunn/features/auth/data/remote/login_dto.dart';

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginDto loginDto;
  const LoginSuccess({required this.loginDto});
}

class LoginError extends LoginState {
  final String message;
  const LoginError({required this.message});
}