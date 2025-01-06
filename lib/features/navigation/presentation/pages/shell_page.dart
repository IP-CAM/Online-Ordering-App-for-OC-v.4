import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';
import '../../../../config/routes/route_constants.dart';

class ShellPage extends StatelessWidget {
  final Widget child;

  const ShellPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigation(context, location),
      floatingActionButton: const ThemeModeFAB(),
    );
  }

  Widget _buildBottomNavigation(BuildContext context, String location) {
    return NavigationBar(
      selectedIndex: _getSelectedIndex(location),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 65,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: 'Menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: 'About',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }

  int _getSelectedIndex(location) {

    
    // Define routes in order of navigation items
    final routes = [
      RouteConstants.home,
      RouteConstants.menu,
      RouteConstants.cart,
      RouteConstants.about,
      RouteConstants.account,
    ];

    // Find matching route
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