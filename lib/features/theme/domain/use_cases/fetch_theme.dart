import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/theme/domain/entities/theme_entity.dart';
import 'package:ordering_app/features/theme/domain/repositories/theme_repository.dart';

class FetchTheme implements UseCase<ThemeEntity, NoParams> {
  final ThemeRepository themeRepository;

  FetchTheme(this.themeRepository);

  @override
  Future<Either<Failure, ThemeEntity>> call(NoParams params) async {
    return await themeRepository.getTheme();
  }
}
