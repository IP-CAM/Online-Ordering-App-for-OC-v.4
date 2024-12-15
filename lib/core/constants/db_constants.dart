/// Database table names
class DbTables {
  static const String theme = 'theme';
  static const String loginInfo = 'login_info';
}

/// Database column names
class DbColumns {
  static const String id = 'id';

  // Theme
  static const String themeMode = 'theme_mode';

  // Login info
  static const String token = 'token';
  static const String deviceId = 'deviceId';
  static const String email = 'email';
  static const String firstName = 'firstName';
  static const String lastName = 'lastName';
  static const String telephone = 'telephone';
  static const String expiresAt = 'expiresAt';
}

/// Default values
class DbDefaults {
  static const String systemTheme = 'system';
}
