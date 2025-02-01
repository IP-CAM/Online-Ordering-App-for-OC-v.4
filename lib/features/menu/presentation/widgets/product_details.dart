import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/dependencies/dependencies.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_price.dart';

class ProductDetails extends StatelessWidget {
  final ProductEntity product;
  final bool showAddToCart;

  const ProductDetails({
    super.key,
    required this.product,
    required this.showAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 14),
          ProductPrice(product: product),
          if (showAddToCart) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: BlocConsumer<MenuBloc, MenuState>(
                listener: (context, state) {
                  if (state is MenuFailure) {
                    showCustomSnackBar(
                      context: context,
                      message: decodeHtmlEntities(state.error),
                      type: SnackBarType.error,
                    );
                  }

                  if (state is AddToCartSuccess) {
                    showCustomSnackBar(
                      context: context,
                      message: decodeHtmlEntities(state.message),
                      type: SnackBarType.success,
                    );
                    BlocProvider.of<CartBloc>(context).add(CartFetchEvent());
                  }
                },
                builder: (context, state) {
                  if (state is MenuLoading) {
                    return ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const CircularProgressIndicator(),
                    );
                  }
                  return ElevatedButton.icon(
                    onPressed: product.quantity > 0
                        ? () {
                            final authState = serviceLocator<AuthCubit>().state;

                            if (authState is AuthInitial) {
                              showCustomSnackBar(
                                context: context,
                                message: "Login to add items to cart!",
                                type: SnackBarType.warning,
                              );

                              NavigationService.push(
                                  context, RouteConstants.login);
                              return;
                            }

                            if (product.options.isEmpty) {
                              BlocProvider.of<MenuBloc>(context)
                                  .add(AddToCartEvent(cartData: {
                                'product_id': product.productId.toString(),
                                'quantity': '1',
                                'option': const [],
                              }));
                            } else {
                              NavigationService.pushWithQuery(
                                  context,
                                  RouteConstants.productView,
                                  {'product': product});
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                    label: const Text('Add to Cart'),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
