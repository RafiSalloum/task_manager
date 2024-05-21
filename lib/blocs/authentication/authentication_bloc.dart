import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/repositories/authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SharedPreferences sharedPreferences;
  final AuthenticationRepository authenticationRepository;

  AuthenticationBloc(
      {required this.sharedPreferences, required this.authenticationRepository})
      : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState(event);
    }
  }

  Stream<AuthenticationState> _mapLoginEventToState(LoginEvent event) async* {
    yield AuthenticationLoading();
    try {
      final username = event.username;
      final password = event.password;
      final bool loginSuccess = await authenticationRepository.login(
        username,
        password,
      );
      if (loginSuccess) {
        yield AuthenticationSuccess();
      } else {
        yield AuthenticationFailure(errorMessage: 'Login failed');
      }
      sharedPreferences.setBool('isLoggedIn', true);
    } catch (e) {
      yield AuthenticationFailure(errorMessage: 'Login failed');
    }
  }
}