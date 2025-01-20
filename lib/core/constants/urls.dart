class Urls {
  static const String baseUrl = 'http://127.0.0.1/opencart/mobileapi/';

  static const String connectionTest = 'test|connection';

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
  static const String setShippingAddress = 'checkout|setShippingAddress';
  static const String getShippingMethods = 'checkout|getShippingMethods';
  static const String setShippingMethod = 'checkout|setShippingMethod';
  static const String fetchPaymentMethods = 'checkout|fetchPaymentMethods';
  static const String setPaymentMethod = 'checkout|setPaymentMethod';
  static const String confirmOrder = 'checkout|confirmOrder';
  static const String applyVoucher = 'checkout|applyVoucher';
  static const String removeVoucher = 'checkout|removeVoucher';
  static const String applyCoupon = 'checkout|applyCoupon';
  static const String removeCoupon = 'checkout|removeCoupon';
  static const String applyReward = 'checkout|applyReward';
  static const String removeReward = 'checkout|removeReward';
  static const String reviewOrder = 'checkout|reviewOrder';


}
