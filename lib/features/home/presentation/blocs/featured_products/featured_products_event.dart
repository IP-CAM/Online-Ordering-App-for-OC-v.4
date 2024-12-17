part of 'featured_products_bloc.dart';

@immutable
sealed class FeaturedProductsEvent {}

final class FetchFeaturedProductsEvent extends FeaturedProductsEvent {}
