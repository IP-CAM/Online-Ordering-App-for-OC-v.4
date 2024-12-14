import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';

class SaveTheme implements UseCase<void, SaveThemeParams> {
  final ThemeRepository themeRepository;

  SaveTheme(this.themeRepository);

  @override
  Future<Either<Failure, void>> call(SaveThemeParams params) async {
    return await themeRepository.saveTheme(isDarkMode: params.isDarkMode);
  }
}

class SaveThemeParams {
  final bool isDarkMode;

  SaveThemeParams({required this.isDarkMode});
}
