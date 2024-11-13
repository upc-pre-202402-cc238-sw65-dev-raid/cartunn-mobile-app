abstract class LoginEvent {
  const LoginEvent();
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});
}