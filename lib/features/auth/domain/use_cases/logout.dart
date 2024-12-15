import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class Logout implements UseCase<void, NoParams> {
  final AuthRepository _authRepository;
  Logout(AuthRepository authRepository) : _authRepository = authRepository;
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}
