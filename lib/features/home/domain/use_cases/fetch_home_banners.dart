import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/home/domain/entities/home_banner_entity.dart';
import 'package:ordering_app/features/home/domain/repositories/home_repository.dart';

class FetchHomeBanners implements UseCase<List<HomeBannerEntity>, NoParams> {
  final HomeRepository _homeRepository;

  FetchHomeBanners({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<Either<Failure, List<HomeBannerEntity>>> call(NoParams params) async {
    return await _homeRepository.getHomeBanners();
  }
}
