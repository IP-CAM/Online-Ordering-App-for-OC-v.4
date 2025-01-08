part of 'menu_bloc.dart';

@immutable
sealed class MenuEvent {}

final class FetchCategoriesEvent extends MenuEvent{}
final class FetchProductsEvent extends MenuEvent{
  final List<int> productIds;

  FetchProductsEvent({required this.productIds});
}
final class AddToCartEvent extends MenuEvent{
  final Map<String,dynamic> cartData;

  AddToCartEvent({required this.cartData});
}
