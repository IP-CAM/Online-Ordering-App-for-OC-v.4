import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/home/domain/repositories/home_repository.dart';

class FetchFeaturedProducts implements UseCase<List<ProductEntity>,NoParams> {
  final HomeRepository _homeRepository;

  FetchFeaturedProducts({required HomeRepository homeRepository}) : _homeRepository = homeRepository;
  @override
  Future<Either<Failure, List<ProductEntity>>> call(NoParams params)async {
   return await _homeRepository.getFeaturedProducts();
  }
}