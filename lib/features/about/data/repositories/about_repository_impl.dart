import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/about/data/data_sources/about_remote_data_source.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';
import 'package:ordering_app/features/about/domain/repositories/about_repository.dart';

class AboutRepositoryImpl implements AboutRepository {
  final AboutRemoteDataSource _aboutRemoteDataSource;

  AboutRepositoryImpl({required AboutRemoteDataSource aboutRemoteDataSource})
      : _aboutRemoteDataSource = aboutRemoteDataSource;
  @override
  Future<Either<Failure, InfoEntity>> getInfo() async {
    try {
      final res = await _aboutRemoteDataSource.getInfo();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
