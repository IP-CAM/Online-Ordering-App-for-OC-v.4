import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/address_book/presentation/pages/address_book_page.dart';
import 'package:ordering_app/features/address_book/presentation/pages/address_details_page.dart';
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
          key: state.pageKey,
          child: const SplashPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.register,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignUpPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.addressBook,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AddressBookPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: RouteConstants.addressDetailsPage,
        pageBuilder: (BuildContext context, GoRouterState state) {
          // Extract address from state.extra safely
          final Map<String, dynamic>? extras =
              state.extra as Map<String, dynamic>?;
          final AddressEntity? address = extras?['address'] as AddressEntity?;

          return CustomTransitionPage<void>(
            key: state.pageKey,
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
      ShellRoute(
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: RouteConstants.home,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.menu,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.cart,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.about,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          GoRoute(
            path: RouteConstants.account,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AccountPage(),
              transitionDuration: const Duration(milliseconds: 200),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
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

    if (isAuth &&
        [RouteConstants.login, RouteConstants.register]
            .contains(state.matchedLocation)) {
      return RouteConstants.account;
    }

    if (!isAuth && !publicRoutes.contains(state.matchedLocation)) {
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
