import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';
import 'package:ordering_app/features/about/domain/repositories/about_repository.dart';

class FetchInfo implements UseCase<InfoEntity, NoParams> {
  final AboutRepository _aboutRepository;

  FetchInfo({required AboutRepository aboutRepository})
      : _aboutRepository = aboutRepository;
  @override
  Future<Either<Failure, InfoEntity>> call(NoParams params) async {
    return await _aboutRepository.getInfo();
  }
}
