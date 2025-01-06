import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccount implements UseCase<String,DeleteAccountParams> {
  final AuthRepository _authRepository;

  DeleteAccount({required AuthRepository authRepository}) : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(DeleteAccountParams params) async{
   return await _authRepository.deleteCustomer(password: params.password);
  }
}

class DeleteAccountParams {
  final String password;

  DeleteAccountParams({required this.password});
}
