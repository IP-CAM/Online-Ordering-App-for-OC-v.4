
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/splash/domain/repositories/splash_repository.dart';

class FetchMenu implements UseCase<void,NoParams> {
  final SplashRepository _splashRepository;

  FetchMenu({required SplashRepository splashRepository}) : _splashRepository = splashRepository;
  @override
  Future<Either<Failure, void>> call(NoParams params)async {
    return await _splashRepository.loadMenu();
  }
}