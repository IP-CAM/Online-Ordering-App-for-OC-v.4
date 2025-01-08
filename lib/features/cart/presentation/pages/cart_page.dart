import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:ordering_app/features/cart/presentation/widgets/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  void _loadCart() {
    context.read<CartBloc>().add(CartFetchEvent());
  }

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoading) {
            Loader.show(context);
          } else {
            Loader.hide();
          }
      
          if (state is CartFailure) {
            showCustomSnackBar(
              context: context,
              message: state.error,
              type: SnackBarType.error,
            );
          }
      
          if (state is CartUpdateSuccess) {
            showCustomSnackBar(
              context: context,
              message: state.message,
              type: SnackBarType.success,
            );
      
            _loadCart();
          }
        },
        builder: (context, state) {
          if (state is CartFetchSuccess) {
            final List<CartItemEntity> cartItems = state.cartItems;
      
            if (cartItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your cart is empty',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () => NavigationService.push(context, RouteConstants.menu,),
                      child: const Text('Continue Shopping'),
                    ),
                  ],
                ),
              );
            }
      
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemCard(item: item);
                    },
                  ),
                ),
                CartSummary(cartItems: cartItems),
              ],
            );
          }
      
          return const SizedBox();
        },
      ),
    );
  }
}
