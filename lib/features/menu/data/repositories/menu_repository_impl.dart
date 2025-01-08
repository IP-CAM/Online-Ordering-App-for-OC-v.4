import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/menu/data/data_sources/menu_local_data_source.dart';
import 'package:ordering_app/features/menu/data/data_sources/menu_remote_data_source.dart';
import 'package:ordering_app/features/menu/domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuLocalDataSource _menuLocalDataSource;
  final MenuRemoteDataSource _menuRemoteDataSource;

  MenuRepositoryImpl(
      {required MenuLocalDataSource menuLocalDataSource,
      required MenuRemoteDataSource menuRemoteDataSource})
      : _menuLocalDataSource = menuLocalDataSource,
        _menuRemoteDataSource = menuRemoteDataSource;
  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final res = await _menuLocalDataSource.getCategories();
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProductsByIds({
    required List<int> productIds,
  }) async {
    try {
      final res =
          await _menuLocalDataSource.getProductsByIds(productIds: productIds);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> addToCart(
      {required Map<String, dynamic> cartData}) async {
    try {
      final res = await _menuRemoteDataSource.addToCart(cartData: cartData);
      return right(res);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
