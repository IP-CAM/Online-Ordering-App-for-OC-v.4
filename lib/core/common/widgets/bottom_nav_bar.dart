import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/config/routes/route_constants.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(RouteConstants.home)) return 0;
    if (location.startsWith(RouteConstants.menu)) return 1;
    if (location.startsWith(RouteConstants.cart)) return 2;
    if (location.startsWith(RouteConstants.about)) return 3;
    if (location.startsWith(RouteConstants.account)) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    final routes = ['/home', '/menu', '/cart', '/about', '/account'];
    if (index >= 0 && index < routes.length) {
      context.go(routes[index]);
    }
  }


  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(context, index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book), label: 'Menu'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.info), label: 'About'),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Account'),
        ],
      );
  }
}