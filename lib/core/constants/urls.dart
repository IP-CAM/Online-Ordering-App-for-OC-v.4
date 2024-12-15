class Urls {
  static const String baseUrl = 'http://127.0.0.1/opencart/mobileapi/';

  // Auth
  static const String login = "auth|login";
  static const String logout = "auth|logout";
  static const String register = "auth|register";
  static const String validateToken = "auth|validateToken";

  // Menu
  static const String categories = "menu|categories";
  static const String category = "menu|category";
  static const String products = "menu|products";
  static const String product = "menu|product";
  static const String lastUpdated = 'menu|lastUpdated';
}
