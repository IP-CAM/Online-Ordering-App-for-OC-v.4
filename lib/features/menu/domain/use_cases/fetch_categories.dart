import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/menu/domain/repositories/menu_repository.dart';

class FetchCategories implements UseCase<List<CategoryEntity>, NoParams> {
  final MenuRepository _menuRepository;

  FetchCategories({required MenuRepository menuRepository})
      : _menuRepository = menuRepository;
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await _menuRepository.getCategories();
  }
}
