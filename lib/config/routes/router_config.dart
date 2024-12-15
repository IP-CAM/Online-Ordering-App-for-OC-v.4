import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/dependencies/dependencies.dart';
import 'package:ordering_app/features/auth/presentation/pages/login_page.dart';
import 'package:ordering_app/features/auth/presentation/pages/signup_page.dart';
import 'package:ordering_app/features/home/presentation/pages/home_page.dart';
import 'route_constants.dart';

class AppRouter {
  AppRouter._();
  static final AppRouter instance = AppRouter._();

  final authCubit = serviceLocator<AuthCubit>();

  List<String> publicRoutes = [
    RouteConstants.login,
    RouteConstants.register,
    RouteConstants.home,
  ];

  late final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: RouteConstants.login,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: _globalRedirect,
    routes: [
      GoRoute(
        path: RouteConstants.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        name: 'register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: RouteConstants.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );

  Future<String?> _globalRedirect(
      BuildContext context, GoRouterState state) async {
    final isAuth = authCubit.state is AuthSuccess;

    // If the user is not logged in and trying to access any route except public routes
    if (!isAuth && !publicRoutes.contains(state.matchedLocation)) {
      return RouteConstants.login;
    }

    // If the user is logged in and trying to access login/register
    if (isAuth &&
        [RouteConstants.login, RouteConstants.register]
            .contains(state.matchedLocation)) {
      return RouteConstants.home;
    }

    return null;
  }
}

// Custom RefreshListenable that converts a Stream to a Listenable
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
