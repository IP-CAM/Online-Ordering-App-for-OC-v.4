import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';

abstract interface class SplashRepository {
  Future<Either<Failure,void>> loadMenu();
}