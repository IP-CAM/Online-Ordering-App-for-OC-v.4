import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:ordering_app/features/theme/data/models/theme_model.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource themeLocalDataSource;

  ThemeRepositoryImpl(this.themeLocalDataSource);
  @override
  Future<Either<Failure, ThemeModel>> getTheme() async {
    try {
      final res = await themeLocalDataSource.getTheme();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme({required bool isDarkMode}) async {
    try {
      await themeLocalDataSource.saveTheme(isDarkMode: isDarkMode);
      return right(null);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
