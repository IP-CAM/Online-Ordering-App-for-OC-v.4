import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_card.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class ProductListPage extends StatefulWidget {
  final List<int> productIds;
  const ProductListPage({
    super.key,
    required this.productIds,
  });

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<ProductEntity> _products = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MenuBloc>(context)
        .add(FetchProductsEvent(productIds: widget.productIds));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.inverseSurface),
      ),
      floatingActionButton:const ThemeModeFAB(),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuLoading) {
            Loader.show(context);
          } else {
            Loader.hide();
          }

          if (state is ProductsSuccess) {
            setState(() {
              _products = state.products;
            });
          }
        },
        builder: (context, state) {
          if (_products.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text('No products found!'),
              ),
            );
          }
          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.5,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return Hero(
                tag: 'product_${product.productId}',
                child: ProductCard(
                  product: product,
                  onTap: () {
                    // Implement navigation with hero animation
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
