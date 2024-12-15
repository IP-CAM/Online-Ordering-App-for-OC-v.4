import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/theme/data/data_sources/theme_local_data_source.dart';
import 'package:ordering_app/features/theme/data/models/theme_model.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';

/// Implementation of [ThemeRepository] that manages theme preferences
/// using local storage through [ThemeLocalDataSource]
class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource _dataSource;

  /// Creates a new instance with the required [ThemeLocalDataSource]
  const ThemeRepositoryImpl(ThemeLocalDataSource themeLocalDataSource)
      : _dataSource = themeLocalDataSource;

  @override
  Future<Either<Failure, ThemeModel>> getTheme() async {
    try {
      final theme = await _dataSource.getTheme();
      return right(theme);
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme({required bool isDarkMode}) async {
    try {
      await _dataSource.saveTheme(isDarkMode: isDarkMode);
      return right(null);
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    } catch (e) {
      return left(UnexpectedFailure(e.toString()));
    }
  }
}
