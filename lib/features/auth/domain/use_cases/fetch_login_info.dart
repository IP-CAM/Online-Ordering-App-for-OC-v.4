
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class FetchLoginInfo implements UseCase<LoginInfoEntity,NoParams> {
  final AuthRepository _authRepository;

  FetchLoginInfo(AuthRepository authRepository):_authRepository=authRepository;
  @override
  Future<Either<Failure, LoginInfoEntity>> call(NoParams params) async{
    return await _authRepository.getLoginInfo();
  }

}