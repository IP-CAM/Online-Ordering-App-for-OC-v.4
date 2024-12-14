class RouteConstants {
  RouteConstants._();

  // Public routes
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  
  // Protected routes
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String details = '/details';
  static const String detailsId = '/details/:id';
  
  // Nested routes
  static const String profileSettings = '/profile/settings';

  // Query parameter keys
  static const String idParam = 'id';
  static const String filterParam = 'filter';
  
  // Redirect location
  static const String defaultRedirect = '/login';
}