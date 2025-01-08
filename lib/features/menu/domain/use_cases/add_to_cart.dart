import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/menu/domain/repositories/menu_repository.dart';

class AddToCart implements UseCase<String, AddToCartParams> {
  final MenuRepository _menuRepository;

  AddToCart({required MenuRepository menuRepository}) : _menuRepository = menuRepository;

  @override
  Future<Either<Failure, String>> call(AddToCartParams params) async{
return await _menuRepository.addToCart(cartData: params.cartData);
  }
}

class AddToCartParams {
  final Map<String, dynamic> cartData;

  AddToCartParams({required this.cartData});
}
