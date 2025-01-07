import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/domain/repositories/address_book_repository.dart';

class FetchAddressList implements UseCase<List<AddressEntity>, NoParams> {
  final AddressBookRepository _addressBookRepository;

  FetchAddressList({required AddressBookRepository addressBookRepository})
      : _addressBookRepository = addressBookRepository;
  @override
  Future<Either<Failure, List<AddressEntity>>> call(NoParams params) async {
    return await _addressBookRepository.getAddressList();
  }
}
