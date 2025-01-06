// lib/features/navigation/presentation/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/routes/route_constants.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  RouterDelegate<Object>? _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routerDelegate = GoRouter.of(context).routerDelegate;
    _routerDelegate?.addListener(_handleRouteChange);
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_handleRouteChange);
    _routerDelegate = null;
    super.dispose();
  }

  void _handleRouteChange() {
    if (mounted) {
      setState(() {});
    }
  }

  int _getSelectedIndex() {
    final state = GoRouterState.of(context);
    // Get the final matched location after redirects
    final location = state.matchedLocation;
    
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

  void _onNavItemTapped(BuildContext context, int index) {
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

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex();
    
    return NavigationBar(
      selectedIndex: selectedIndex != -1 ? selectedIndex : 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      height: 65,
      onDestinationSelected: (index) => _onNavItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
          tooltip: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.restaurant_menu_outlined),
          selectedIcon: Icon(Icons.restaurant_menu),
          label: 'Menu',
          tooltip: 'Menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          selectedIcon: Icon(Icons.shopping_cart),
          label: 'Cart',
          tooltip: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.info_outline),
          selectedIcon: Icon(Icons.info),
          label: 'About',
          tooltip: 'About',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
          tooltip: 'Profile',
        ),
      ],
    );
  }
}