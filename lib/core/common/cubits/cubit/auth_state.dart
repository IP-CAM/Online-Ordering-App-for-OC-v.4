part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AuthSuccess extends AuthState {
  final LoginInfoEntity loginInfoEntity;

  AuthSuccess(this.loginInfoEntity);
}
