import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class Login implements UseCase<LoginInfoEntity, LoginParams> {
  final AuthRepository _authRepository;
  Login(AuthRepository authRepository) : _authRepository = authRepository;
  @override
  Future<Either<Failure, LoginInfoEntity>> call(LoginParams params) async {
    return await _authRepository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
