/// Database table names
class DbTables {
  static const String theme = 'theme';
  static const String loginInfo = 'login_info';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String lastModified = 'lastModified';

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

  // Menu

  static const String categoryId = 'categoryId';
  static const String name = 'name';
  static const String description = 'description';
  static const String image = 'image';
  static const String sortOrder = 'sortOrder';
  static const String status = 'status';
  static const String productCount = 'productCount';
  static const String products = 'products';
  static const String parentId = 'parentId';

  
  static const String productId = 'productId';
  static const String metaTitle = 'metaTitle';
  static const String metaDescription = 'metaDescription';
  static const String metaKeyword = 'metaKeyword';
  static const String model = 'model';
  static const String sku = 'sku';
  static const String upc = 'upc';
  static const String ean = 'ean';
  static const String jan = 'jan';
  static const String isbn = 'isbn';
  static const String mpn = 'mpn';
  static const String location = 'location';
  static const String quantity = 'quantity';
  static const String stockStatus = 'stockStatus';
  static const String additionalImages = 'additionalImages';
  static const String categories = 'categories';
  static const String price = 'price';
  static const String special = 'special';
  static const String taxClassId = 'taxClassId';
  static const String dateAvailable = 'dateAvailable';
  static const String weight = 'weight';
  static const String weightClassId = 'weightClassId';
  static const String length = 'length';
  static const String width = 'width';
  static const String height = 'height';
  static const String lengthClassId = 'lengthClassId';
  static const String minimum = 'minimum';
  static const String dateAdded = 'dateAdded';
  static const String dateModified = 'dateModified';
  static const String viewed = 'viewed';
  static const String options = 'options';

  static const String date = 'date';

  


}

/// Default values
class DbDefaults {
  static const String systemTheme = 'system';
}
