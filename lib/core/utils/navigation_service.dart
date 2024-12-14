// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';


// class NavigationService {
//   NavigationService._();
//   static final NavigationService instance = NavigationService._();
//   final _authService = AuthService.instance;

//   // Public route navigation
//   void goToHome(BuildContext context) {
//     context.goNamed('home');
//   }

//   void goToLogin(BuildContext context) {
//     context.goNamed('login');
//   }

//   // Protected route navigation
//   Future<void> goToProfile(BuildContext context) async {
//     if (await _authService.checkAuth()) {
//       context.goNamed('profile');
//     } else {
//       goToLogin(context);
//     }
//   }

//   Future<void> goToSettings(BuildContext context) async {
//     if (await _authService.checkAuth()) {
//       context.goNamed('profileSettings');
//     } else {
//       goToLogin(context);
//     }
//   }

//   Future<void> goToDetails(BuildContext context, {String? id}) async {
//     if (await _authService.checkAuth()) {
//       if (id != null) {
//         context.goNamed('detailsWithId', pathParameters: {'id': id});
//       } else {
//         context.goNamed('details');
//       }
//     } else {
//       goToLogin(context);
//     }
//   }

//   // General navigation methods
//   void push(BuildContext context, String location) {
//     context.push(location);
//   }

//   void pop(BuildContext context) {
//     context.pop();
//   }

//   void pushReplacement(BuildContext context, String location) {
//     context.pushReplacement(location);
//   }

//   // Navigate with query parameters
//   void navigateWithQuery(BuildContext context, String location, Map<String, String> queryParams) {
//     context.push(location, extra: queryParams);
//   }

//   // Handle logout navigation
//   Future<void> logout(BuildContext context) async {
//     await _authService.logout();
//     goToLogin(context);
//   }
// }