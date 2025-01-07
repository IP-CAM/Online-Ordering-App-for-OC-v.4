import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/address_book/domain/entities/zone_entity.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';

class FetchZoneList implements UseCase<List<ZoneEntity>, FetchZoneListParams> {
  final AddressBookRepository _addressBookRepository;

  FetchZoneList({required AddressBookRepository addressBookRepository})
      : _addressBookRepository = addressBookRepository;

  @override
  Future<Either<Failure, List<ZoneEntity>>> call(
      FetchZoneListParams params) async {
    return await _addressBookRepository.getZoneList(
        countryId: params.countryId);
  }
}

class FetchZoneListParams {
  final int countryId;

  FetchZoneListParams({required this.countryId});
}
