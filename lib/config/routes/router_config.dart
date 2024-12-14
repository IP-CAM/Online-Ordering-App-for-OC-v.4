// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'route_constants.dart';

// class AppRouter {
//   AppRouter._();
//   static final AppRouter instance = AppRouter._();
//   final _authService = AuthService.instance;

//   late final GoRouter router = GoRouter(
//     debugLogDiagnostics: true,
//     initialLocation: RouteConstants.home,
//     redirect: _globalRedirect,
//     routes: [
//       // Public routes
//       GoRoute(
//         path: RouteConstants.home,
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//       GoRoute(
//         path: RouteConstants.login,
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),

//       // Protected routes
//       ShellRoute(
//         builder: (context, state, child) {
//           // You can wrap protected routes with a common shell (e.g., dashboard layout)
//           return Scaffold(
//             body: child,
//             // Add common navigation elements here
//           );
//         },
//         routes: [
//           GoRoute(
//             path: RouteConstants.profile,
//             name: 'profile',
//             builder: (context, state) => const ProfileScreen(),
//             routes: [
//               GoRoute(
//                 path: 'settings',
//                 name: 'profileSettings',
//                 builder: (context, state) => const SettingsScreen(),
//               ),
//             ],
//           ),
//           GoRoute(
//             path: RouteConstants.details,
//             name: 'details',
//             builder: (context, state) => const DetailsScreen(),
//           ),
//           GoRoute(
//             path: RouteConstants.detailsId,
//             name: 'detailsWithId',
//             builder: (context, state) {
//               final id = state.pathParameters['id'];
//               return DetailsScreen(id: id);
//             },
//           ),
//         ],
//       ),
//     ],
//     errorBuilder: (context, state) => Scaffold(
//       body: Center(
//         child: Text('Error: ${state.error}'),
//       ),
//     ),
//   );

//   Future<String?> _globalRedirect(
//       BuildContext context, GoRouterState state) async {
//     final isAuth = await _authService.checkAuth();
//     final isLoggingIn = state.matchedLocation == RouteConstants.login;

//     // List of public routes that don't require authentication
//     final publicRoutes = [
//       RouteConstants.login,
//       RouteConstants.home,
//       RouteConstants.register,
//     ];

//     // If the user is not logged in and trying to access a protected route
//     if (!isAuth && !publicRoutes.contains(state.matchedLocation)) {
//       // Save the attempted route for after login
//       final redirectTo = state.matchedLocation;
//       return '${RouteConstants.login}?redirectTo=$redirectTo';
//     }

//     // If the user is logged in and trying to access login page
//     if (isAuth && isLoggingIn) {
//       return RouteConstants.profile;
//     }

//     // Handle redirect after login
//     if (isAuth && state.uri.queryParameters.containsKey('redirectTo')) {
//       final redirectTo = state.uri.queryParameters['redirectTo']!;
//       return redirectTo;
//     }

//     return null;
//   }
// }
