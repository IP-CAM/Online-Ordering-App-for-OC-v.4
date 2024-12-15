part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

final class LogoutEvent extends AuthEvent {}

final class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String telephone;
  final String password;
  final String confirm;
  final bool agree;
  final bool newsletter;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.telephone,
    required this.password,
    required this.confirm,
    required this.agree,
    required this.newsletter,
  });
}

final class FetchLoginInfoEvent extends AuthEvent {}
