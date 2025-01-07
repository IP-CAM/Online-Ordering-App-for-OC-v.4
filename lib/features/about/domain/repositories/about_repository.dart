import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';

abstract interface class AboutRepository {
  Future<Either<Failure,InfoEntity>> getInfo();
}