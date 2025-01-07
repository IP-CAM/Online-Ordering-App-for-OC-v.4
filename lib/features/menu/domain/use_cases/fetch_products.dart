import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/menu/domain/repositories/menu_repository.dart';

class FetchProducts
    implements UseCase<List<ProductEntity>, FetchProductsParams> {
  final MenuRepository _menuRepository;

  FetchProducts({required MenuRepository menuRepository})
      : _menuRepository = menuRepository;

  @override
  Future<Either<Failure, List<ProductEntity>>> call(
      FetchProductsParams params) async {
    return await _menuRepository.getProductsByIds(
        productIds: params.productIds);
  }
}

class FetchProductsParams {
  final List<int> productIds;

  FetchProductsParams({required this.productIds});
}
