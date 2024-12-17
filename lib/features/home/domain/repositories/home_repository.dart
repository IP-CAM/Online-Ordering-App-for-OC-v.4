import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/home/domain/entities/home_banner_entity.dart';

abstract interface class HomeRepository {
  Future<Either<Failure,List<HomeBannerEntity>>> getHomeBanners();
  Future<Either<Failure,List<ProductEntity>>> getFeaturedProducts();
}