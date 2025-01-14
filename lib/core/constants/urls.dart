class Urls {
  static const String baseUrl = 'http://127.0.0.1/opencart/mobileapi/';

  // Auth
  static const String login = "auth|login";
  static const String logout = "auth|logout";
  static const String register = "auth|register";
  static const String validateToken = "auth|validateToken";
  static const String deleteAccount = "auth|deleteAccount";
  static const String forgotPassword = "auth|forgotPassword";
  static const String resetPassword = "auth|resetPassword";

  // Menu
  static const String categories = "menu|categories";
  static const String category = "menu|category";
  static const String products = "menu|products";
  static const String product = "menu|product";
  static const String lastModified = 'menu|lastModified';
  static const String featured = 'menu|featured';

  // Home
  static const String banner = 'home|banner';

  // Address book

  static const String addressList = 'address|list';
  static const String countryList = 'address|countries';
  static const String country = 'address|country';
  static const String saveAddress = 'address|save';
  static const String delete = 'address|delete';

  // About

  static const String storeInfo = 'about|info';

  // Cart

  static const String addToCart = 'cart|add';
  static const String getCartSummary = 'cart|summary';
  static const String updateCart = 'cart|update';
  static const String deleteCart = 'cart|remove';

  // Checkout

  static const String summary = 'checkout|summary';
  static const String setShippingAddress = 'checkout|set_shipping_address';
  static const String shippingMethods = 'checkout|shipping_methods';
  static const String setShippingMethod = 'checkout|set_shipping_method';
  static const String paymentMethods = 'checkout|payment_methods';
  static const String setPaymentMethod = 'checkout|set_payment_method';
  static const String confirm = 'checkout|confirm';
  static const String addVoucher = 'checkout|addVoucher';
  static const String removeVoucher = 'checkout|removeVoucher';
  static const String saveCoupon = 'checkout|saveCoupon';

}
