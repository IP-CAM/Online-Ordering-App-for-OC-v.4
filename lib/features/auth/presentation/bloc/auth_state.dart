part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final LoginInfoEntity loginInfoEntity;

  AuthSuccess(this.loginInfoEntity);
}

final class AuthLogoutSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}

final class AuthInitialSuccess extends AuthState {
  final LoginInfoEntity loginInfoEntity;

  AuthInitialSuccess({required this.loginInfoEntity});
}

final class AccountDeleteSuccess extends AuthState {
  final String message;

  AccountDeleteSuccess({required this.message});
}

final class ForgotPasswordSuccess extends AuthState {
  final String message;

  ForgotPasswordSuccess(this.message);
}

final class ResetPasswordSuccess extends AuthState {
  final String message;

  ResetPasswordSuccess({required this.message});
}
