import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPassword implements UseCase<String, ResetPasswordParams> {
  final AuthRepository _authRepository;

  ResetPassword({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) async {
    return await _authRepository.resetPassword(
      password: params.password,
      confirm: params.confirm,
    );
  }
}

class ResetPasswordParams {
  final String password;
  final String confirm;

  ResetPasswordParams({
    required this.password,
    required this.confirm,
  });
}
