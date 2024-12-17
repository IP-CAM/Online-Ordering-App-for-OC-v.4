part of 'featured_products_bloc.dart';

@immutable
sealed class FeaturedProductsState {}

final class FeaturedProductsInitial extends FeaturedProductsState {}
final class FeaturedProductsLoading extends FeaturedProductsState {}
final class FeaturedProductsSuccess extends FeaturedProductsState {
  final List<ProductEntity> products;

  FeaturedProductsSuccess(this.products);
}
final class FeaturedProductsFailure extends FeaturedProductsState {
  final String error;

  FeaturedProductsFailure(this.error);
}
