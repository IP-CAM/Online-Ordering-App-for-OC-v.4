import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/core/common/models/category_model.dart';
import 'package:ordering_app/core/common/models/product_model.dart';

abstract interface class SplashRemoteDataSource {
  Future<DateTime> lastModified();
  Future<List<CategoryModel>> categories();
  Future<List<ProductModel>> products();
}

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  final WebService _webService;

  const SplashRemoteDataSourceImpl({
    required WebService webService,
  }) : _webService = webService;

  @override
  Future<List<CategoryModel>> categories() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.categories,
      );
      debugPrint(response.data.toString());
      if (response.error != null) {
        throw response.error.toString();
      }
      List<CategoryModel> categoryList = [];

      if (response.success && response.data is Map) {
        for (final item in response.data['categories']) {
          final category = {
            'categoryId': item['category_id'],
            'name': item['name'],
            'description': item['description'],
            'image': item['image'],
            'sortOrder': item['sort_order'],
            'status': item['status'],
            'productCount': item['product_count'],
            'products': item['products'],
            'parentId': item['parent_id'],
          };
          categoryList.add(CategoryModel.fromMap(category));
        }
      }

      return categoryList;
    } catch (error, stackTrace) {
      debugPrint('Error loading categories: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<DateTime> lastModified() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.lastModified,
      );
      debugPrint(response.data.toString());
      if (response.error != null) {
        throw response.error.toString();
      }
      DateTime lastModified = DateTime.now();

      if (response.success && response.data is Map) {
        lastModified = DateTime.parse(response.data['last_modified']);
      }
      return lastModified;
    } catch (error, stackTrace) {
      debugPrint('Error loading last modified: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }

  @override
  Future<List<ProductModel>> products() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.products,
      );
      debugPrint(response.data.toString());
      if (response.error != null) {
        throw response.error.toString();
      }

      List<ProductModel> products = [];

      if (response.success && response.data is Map) {
        for (final item in response.data['products']) {
          final product = {
    'productId': item['product_id'],
    'name': item['name'],
    'description': item['description'],
    'metaTitle': item['meta_title'],
    'metaDescription': item['meta_description'],
    'metaKeyword': item['meta_keyword'],
    'model': item['model'],
    'sku': item['sku'],
    'upc': item['upc'],
    'ean': item['ean'],
    'jan': item['jan'],
    'isbn': item['isbn'],
    'mpn': item['mpn'],
    'location': item['location'],
    'quantity': item['quantity'],
    'stockStatus': item['stock_status'],
    'image': item['image'],
    'additionalImages': item['additional_images'],
    'categories': item['categories'],
    'price': item['price'],
    'special': item['special'],
    'taxClassId': item['tax_class_id'],
    'dateAvailable': item['date_available'],
    'weight': item['weight'],
    'weightClassId': item['weight_class_id'],
    'length': item['length'],
    'width': item['width'],
    'height': item['height'],
    'lengthClassId': item['length_class_id'],
    'minimum': item['minimum'],
    'sortOrder': item['sort_order'],
    'status': item['status'],
    'dateAdded': item['date_added'],
    'dateModified': item['date_modified'],
    'viewed': item['viewed'],
    'options': item['options']
};
          products.add(ProductModel.fromMap(product));
        }
      }

      return products;
    } catch (error, stackTrace) {
      debugPrint('Error loading products: $error');
      debugPrint('Stack trace: $stackTrace');
      throw AppException(error.toString());
    }
  }
}
