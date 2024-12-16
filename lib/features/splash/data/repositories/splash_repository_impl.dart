import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/features/splash/data/data_sources/splash_local_data_source.dart';
import 'package:ordering_app/features/splash/data/data_sources/splash_remote_data_source.dart';
import 'package:ordering_app/features/splash/domain/repositories/splash_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource _splashRemoteDataSource;
  final SplashLocalDataSource _splashLocalDataSource;

  SplashRepositoryImpl({
    required SplashRemoteDataSource splashRemoteDataSource,
    required SplashLocalDataSource splashLocalDataSource,
  })  : _splashRemoteDataSource = splashRemoteDataSource,
        _splashLocalDataSource = splashLocalDataSource;

  @override
  Future<Either<Failure, void>> loadMenu() async {
    try {
      final DateTime? savedLastModified =
          await _splashLocalDataSource.getLastModified();
      final DateTime lastModified =
          await _splashRemoteDataSource.lastModified();

      // Improved DateTime comparison
      final bool needsUpdate = savedLastModified == null ||
          !savedLastModified.isAtSameMomentAs(lastModified);

      debugPrint('Need to fetch menu => ${needsUpdate ? 'Yes' : 'No' }');

      if (needsUpdate) {
        final categories = await _splashRemoteDataSource.categories();
        await _splashLocalDataSource.saveCategories(categories);

        final products = await _splashRemoteDataSource.products();
        await _splashLocalDataSource.saveProducts(products);

        await _splashLocalDataSource.saveLastModified(lastModified);
      }

      return right(null);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
