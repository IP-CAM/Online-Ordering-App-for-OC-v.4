import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/features/about/presentation/pages/about_page.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/presentation/pages/address_book_page.dart';
import 'package:ordering_app/features/address_book/presentation/pages/address_details_page.dart';
import 'package:ordering_app/features/checkout/presentation/pages/cart_page.dart';
import 'package:ordering_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:ordering_app/features/checkout/presentation/pages/order_success_page.dart';
import 'package:ordering_app/features/menu/presentation/pages/menu_page.dart';
import 'package:ordering_app/features/menu/presentation/pages/product_list_page.dart';
import 'package:ordering_app/features/menu/presentation/pages/product_view_page.dart';
import '../../core/common/cubits/cubit/auth_cubit.dart';
import '../../core/dependencies/dependencies.dart';
import '../../features/auth/presentation/pages/account_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/navigation/presentation/pages/shell_page.dart';
import 'route_constants.dart';

class AppRouter {
  AppRouter._();
  static final AppRouter instance = AppRouter._();

  final authCubit = serviceLocator<AuthCubit>();

  List<String> publicRoutes = [
    RouteConstants.login,
    RouteConstants.register,
    RouteConstants.home,
    RouteConstants.splash,
    RouteConstants.menu,
    RouteConstants.products,
    RouteConstants.productView,
    RouteConstants.about,
  ];

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteConstants.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: _globalRedirect,
    routes: [
      GoRoute(
        path: RouteConstants.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: ValueKey('splash-${state.uri.toString()}'),
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: ValueKey('login-${state.uri.toString()}'),
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.register,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: ValueKey('register-${state.uri.toString()}'),
          child: const SignUpPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.addressBook,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final bool? isOnCheckout = extras?['isOnCheckout'] as bool?;

          return CustomTransitionPage<void>(
            key: ValueKey('address-book-${state.uri.toString()}'),
            child: AddressBookPage(
              isOnCheckout: isOnCheckout ?? false,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteConstants.addressDetailsPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final AddressEntity? address = extras?['address'] as AddressEntity?;

          return CustomTransitionPage<void>(
            key: ValueKey('address-details-${state.uri.toString()}'),
            child: AddressDetailsPage(
              address: address,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteConstants.products,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final List<int>? products = extras?['products'] as List<int>?;

          if (extras == null || products == null) {
            return CustomTransitionPage(
              key: ValueKey('products-error-${state.uri.toString()}'),
              child: const Scaffold(
                body: Center(child: Text('Invalid product data')),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          }

          return CustomTransitionPage<void>(
            key: ValueKey('products-${state.uri.toString()}'),
            child: ProductListPage(
              productIds: products,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteConstants.productView,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final ProductEntity? product = extras?['product'] as ProductEntity?;

          if (extras == null || product == null) {
            return CustomTransitionPage(
              key: ValueKey('product-view-error-${state.uri.toString()}'),
              child: const Scaffold(
                body: Center(child: Text('Invalid product data')),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          }

          return CustomTransitionPage<void>(
            key: ValueKey('product-view-${product.productId}-${state.uri.toString()}'),
            child: ProductViewPage(
              product: product,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteConstants.checkout,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final int? addressId = extras?['addressId'] as int?;

          return CustomTransitionPage<void>(
            key: ValueKey('checkout-${addressId ?? 'default'}-${state.uri.toString()}'),
            child: CheckoutPage(
              addressId: addressId,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: RouteConstants.orderSuccess,
        pageBuilder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
          final String? orderId = extras?['orderId'] as String?;

          if (extras == null || orderId == null) {
            return CustomTransitionPage(
              key: ValueKey('order-success-error-${state.uri.toString()}'),
              child: const Scaffold(
                body: Center(child: Text('Invalid order data')),
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            );
          }

          return CustomTransitionPage<void>(
            key: ValueKey('order-success-${orderId}-${state.uri.toString()}'),
            child: OrderSuccessPage(
              orderId: orderId,
            ),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
      ShellRoute(
        builder: (context, state, child) => ShellPage(
          key: ValueKey('shell-${state.uri.toString()}'),
          child: child
        ),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: ValueKey('home-${state.uri.toString()}'),
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.menu,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: ValueKey('menu-${state.uri.toString()}'),
              child: const MenuPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.cart,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: ValueKey('cart-${state.uri.toString()}'),
              child: const CartPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.about,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: ValueKey('about-${state.uri.toString()}'),
              child: const AboutPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.account,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: ValueKey('account-${state.uri.toString()}'),
              child: const AccountPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  Future<String?> _globalRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final isAuth = authCubit.state is AuthSuccess;
    final location = state.uri.toString();

    // Prevent redirect loops
    if (location == RouteConstants.splash) return null;

    if (isAuth && [RouteConstants.login, RouteConstants.register].contains(location)) {
      return RouteConstants.account;
    }

    if (!isAuth && !publicRoutes.contains(location)) {
      return RouteConstants.login;
    }

    return null;
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}