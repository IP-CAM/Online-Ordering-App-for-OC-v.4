import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class Register implements UseCase<LoginInfoEntity, RegisterParams> {
  final AuthRepository _authRepository;
  Register(AuthRepository authRepository) : _authRepository = authRepository;
  @override
  Future<Either<Failure, LoginInfoEntity>> call(RegisterParams params) async {
    return await _authRepository.register(
      firstName: params.firstName,
      lastName: params.lastName,
      email: params.email,
      telephone: params.telephone,
      password: params.password,
      confirm: params.confirm,
      agree: params.agree,
      newsletter: params.newsletter,
    );
  }
}

class RegisterParams {
  final String firstName;
  final String lastName;
  final String email;
  final String telephone;
  final String password;
  final String confirm;
  final bool agree;
  final bool newsletter;

  RegisterParams({
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
