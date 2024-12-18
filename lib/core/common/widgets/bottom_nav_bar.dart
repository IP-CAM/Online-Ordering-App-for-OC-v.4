import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/config/routes/router_config.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late String _location;
  GoRouter? _router;
  RouterDelegate<Object>? _routerDelegate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = AppRouter.instance.router;
    _routerDelegate = _router?.routerDelegate;
    _location =
        _router?.routerDelegate.currentConfiguration.uri.toString() ?? '/';
    _router?.routerDelegate.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    _routerDelegate?.removeListener(_onRouteChanged);
    _router = null;
    _routerDelegate = null;
    super.dispose();
  }

  void _onRouteChanged() {
    if (!mounted) return;
    final newLocation =
        _router?.routerDelegate.currentConfiguration.uri.toString() ?? '/';
    if (_location != newLocation) {
      setState(() {
        _location = newLocation;
      });
    }
  }

  int _calculateSelectedIndex(String location) {
    if (location == RouteConstants.home) return 0;
    if (location == RouteConstants.menu) return 1;
    if (location == RouteConstants.cart) return 2;
    if (location == RouteConstants.about) return 3;
    if (location == RouteConstants.account) return 4;
    return 0;
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
      NavigationService.push(context, routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _calculateSelectedIndex(_router!.state!.fullPath!),
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book),
          label: 'Menu',
        ),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
    );
  }
}
