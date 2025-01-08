part of 'menu_bloc.dart';

@immutable
sealed class MenuState {}

final class MenuInitial extends MenuState {}
final class MenuLoading extends MenuState {}
final class MenuFailure extends MenuState {
  final String error;

  MenuFailure({required this.error});
}
final class CategorySuccess extends MenuState {
final List<CategoryEntity> categories;

  CategorySuccess({required this.categories});
}
final class ProductsSuccess extends MenuState {
  final List<ProductEntity> products;

  ProductsSuccess({required this.products});
}

final class AddToCartSuccess extends MenuState{
  final String message;

  AddToCartSuccess({required this.message});
}
