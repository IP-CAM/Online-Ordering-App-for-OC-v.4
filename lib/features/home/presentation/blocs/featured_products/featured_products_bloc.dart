import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/home/domain/use_cases/fetch_featured_products.dart';

part 'featured_products_event.dart';
part 'featured_products_state.dart';

class FeaturedProductsBloc
    extends Bloc<FeaturedProductsEvent, FeaturedProductsState> {
  final FetchFeaturedProducts _fetchFeaturedProducts;
  FeaturedProductsBloc({
    required FetchFeaturedProducts fetchFeaturedProducts,
  })  : _fetchFeaturedProducts = fetchFeaturedProducts,
        super(FeaturedProductsInitial()) {
    on<FeaturedProductsEvent>((event, emit) {
      emit(FeaturedProductsLoading());
    });
    on<FetchFeaturedProductsEvent>(_onFetchFeaturedProductsEvent);
  }
  void _onFetchFeaturedProductsEvent(
    FetchFeaturedProductsEvent event,
    Emitter<FeaturedProductsState> emit,
  ) async {
    final res = await _fetchFeaturedProducts(NoParams());
    res.fold(
      (l) => emit(FeaturedProductsFailure(l.message)),
      (r) => emit(FeaturedProductsSuccess(r)),
    );
  }
}
