abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String username;
  final String password;

  LoginEvent({required this.username, required this.password});
}
