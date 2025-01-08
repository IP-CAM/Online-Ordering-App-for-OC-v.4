import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import '../../../../config/routes/route_constants.dart';

class ShellPage extends StatefulWidget {
  final Widget child;

  const ShellPage({
    super.key,
    required this.child,
  });

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items when the shell page is initialized
    context.read<CartBloc>().add(CartFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: _buildBottomNavigation(context, location),
      floatingActionButton: const ThemeModeFAB(),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, String location) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return NavigationBar(
          selectedIndex: _getSelectedIndex(location),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 65,
          onDestinationSelected: (index) => _onItemTapped(context, index),
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Badge(
                largeSize: 18,
                isLabelVisible: state is CartFetchSuccess && state.cartItems.isNotEmpty,
                label: Text(
                  state is CartFetchSuccess ? state.cartItems.length.toString() : '0',
                  style: TextStyle(color: appColors.primary),
                ),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                largeSize: 18,
                isLabelVisible: state is CartFetchSuccess && state.cartItems.isNotEmpty,
                label: Text(
                  state is CartFetchSuccess ? state.cartItems.length.toString() : '0',
                  style: TextStyle(color: appColors.primary),
                ),
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.info_outline),
              selectedIcon: Icon(Icons.info),
              label: 'About',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Account',
            ),
          ],
        );
      },
    );
  }

  int _getSelectedIndex(String location) {
    final routes = [
      RouteConstants.home,
      RouteConstants.menu,
      RouteConstants.cart,
      RouteConstants.about,
      RouteConstants.account,
    ];

    return routes.indexWhere((route) => location == route);
  }

  void _onItemTapped(BuildContext context, int index) {
    final routes = [
      RouteConstants.home,
      RouteConstants.menu,
      RouteConstants.cart,
      RouteConstants.about,
      RouteConstants.account,
    ];

    if (index >= 0 && index < routes.length) {
      context.go(routes[index]);
    }
  }
}