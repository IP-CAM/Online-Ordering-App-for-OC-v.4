import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_item_entity.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/cart_item_card.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ScrollController _scrollController = ScrollController();
  double? _savedScrollPosition;

  void _loadCart() {
    if (_scrollController.hasClients) {
      _savedScrollPosition = _scrollController.offset;
    }
    context.read<CartBloc>().add(CartFetchEvent());
  }

  @override
  void initState() {
    super.initState();
    _loadCart();

    // Add scroll listener to continuously update saved position
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        _savedScrollPosition = _scrollController.offset;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _restoreScrollPosition() {
    if (_savedScrollPosition != null) {
      // Delay the scroll restoration to ensure the ListView has been built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          try {
            _scrollController.jumpTo(
              _savedScrollPosition!.clamp(
                0.0,
                _scrollController.position.maxScrollExtent,
              ),
            );
          } catch (e) {
            // Handle any potential errors during scroll restoration
            debugPrint('Error restoring scroll position: $e');
          }
        }
      });
    }
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

          if (state is CartFetchSuccess) {
            _restoreScrollPosition();
          }
        },
        builder: (context, state) {
          if (state is CartFetchSuccess) {
            final cartTotals = state.cartSummary.totals;
            final List<CartItemEntity> cartItems = state.cartSummary.products;
      
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
                      onPressed: () => NavigationService.push(context, RouteConstants.menu),
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
                    key: const PageStorageKey('cart_list'), // Add PageStorageKey
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemCard(item: item);
                    },
                  ),
                ),
                CartSummary(totals: cartTotals),
              ],
            );
          }
      
          return const SizedBox();
        },
      ),
    );
  }
}