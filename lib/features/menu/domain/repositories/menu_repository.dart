import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';

abstract interface class MenuRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<ProductEntity>>> getProductsByIds({
    required List<int> productIds,
  });
}
