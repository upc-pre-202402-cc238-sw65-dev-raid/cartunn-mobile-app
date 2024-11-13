import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cartunn/features/auth/data/remote/auth_service.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_event.dart';
import 'package:cartunn/features/auth/presentation/blocs/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginSubmitted>(
      (event, emit) async {
        emit(LoginLoading());
        try {
          final loginDto = await authService.login(event.username, event.password);
          if (loginDto != null) {
            emit(LoginSuccess(loginDto: loginDto));
          } else {
            emit(const LoginError(message: 'Credenciales incorrectas'));
          }
        } catch (e) {
          emit(LoginError(message: 'Error de autenticación: $e'));
        }
      },
    );
  }
}