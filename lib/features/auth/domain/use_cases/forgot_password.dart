
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword implements UseCase<String,ForgotPasswordParams> {
  final AuthRepository _authRepository;

  ForgotPassword({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params)async {
    return await _authRepository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams{
  final String email;

  ForgotPasswordParams({required this.email});
}