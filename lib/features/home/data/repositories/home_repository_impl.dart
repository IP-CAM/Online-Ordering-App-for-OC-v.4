import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/models/product_model.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:ordering_app/features/home/data/models/home_banner_model.dart';
import 'package:ordering_app/features/home/domain/repositories/home_repository.dart';
import 'package:ordering_app/features/menu/data/data_sources/menu_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final MenuLocalDataSource _menuLocalDataSource;
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImpl({
    required MenuLocalDataSource menuLocalDataSource,
    required HomeRemoteDataSource homeRemoteDataSource,
  })  : _menuLocalDataSource = menuLocalDataSource,
        _homeRemoteDataSource = homeRemoteDataSource;
  @override
  Future<Either<Failure, List<ProductModel>>> getFeaturedProducts() async {
    try {
      final productIds = await _homeRemoteDataSource.getFeaturedProducts();
      final products = await _menuLocalDataSource.getProductsByIds(productIds: productIds);
      return right(products);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<HomeBannerModel>>> getHomeBanners() async {
    try {
      final banners = await _homeRemoteDataSource.getHomeBanners();
      return right(banners);
    } on AppException catch (e) {
      return left(Failure(e.message));
    }
  }
}
