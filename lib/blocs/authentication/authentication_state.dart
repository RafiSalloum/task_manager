abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String? errorMessage;

  AuthenticationFailure({this.errorMessage});
}
class AuthenticationDisconnect extends AuthenticationState {}
