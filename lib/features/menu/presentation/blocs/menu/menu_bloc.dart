import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/menu/domain/use_cases/fetch_categories.dart';
import 'package:ordering_app/features/menu/domain/use_cases/fetch_products.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final FetchCategories _fetchCategories;
  final FetchProducts _fetchProducts;
  MenuBloc({
    required FetchCategories fetchCategories,
    required FetchProducts fetchProducts,
  })  : _fetchCategories = fetchCategories,
        _fetchProducts = fetchProducts,
        super(MenuInitial()) {
    on<MenuEvent>((event, emit) {
      emit(MenuLoading());
    });

    on<FetchCategoriesEvent>(_onFetchCategoriesEvent);
    on<FetchProductsEvent>(_onFetchProductsEvent);
  }

  void _onFetchCategoriesEvent(
    FetchCategoriesEvent event,
    Emitter<MenuState> emit,
  ) async {
    final res = await _fetchCategories(NoParams());
    res.fold(
      (l) => emit(MenuFailure(error: l.message)),
      (r) => emit(CategorySuccess(categories: r)),
    );
  }

  void _onFetchProductsEvent(
    FetchProductsEvent event,
    Emitter<MenuState> emit,
  ) async {
    final res = await _fetchProducts(
      FetchProductsParams(
        productIds: event.productIds,
      ),
    );
    res.fold(
      (l) => emit(MenuFailure(error: l.message)),
      (r) => emit(ProductsSuccess(products: r)),
    );
  }
}
