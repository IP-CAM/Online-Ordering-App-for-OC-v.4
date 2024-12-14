import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';

/// Base UseCase class that defines the contract for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when use case doesn't require any parameters
class NoParams {
  NoParams();
}