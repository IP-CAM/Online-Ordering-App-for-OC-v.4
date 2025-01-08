import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/features/home/presentation/blocs/featured_products/featured_products_bloc.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_card.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeaturedProductsBloc, FeaturedProductsState>(
      builder: (context, state) {
        if (state is FeaturedProductsLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }

        if (state is FeaturedProductsSuccess && state.products.isNotEmpty) {
          return GridView.builder(
            shrinkWrap: true, // Constrains the grid to its content
            physics: const NeverScrollableScrollPhysics(), // Prevents independent scrolling
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.5,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Hero(
                tag: 'product_${product.productId}',
                child: ProductCard(
                  product: product,
                  onTap: () {
                    NavigationService.pushWithQuery(context, RouteConstants.productView, {'product':product});
                  },
                ),
              );
            },
          );
        }

        if (state is FeaturedProductsFailure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Failed to load products',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<FeaturedProductsBloc>()
                        .add(FetchFeaturedProductsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}