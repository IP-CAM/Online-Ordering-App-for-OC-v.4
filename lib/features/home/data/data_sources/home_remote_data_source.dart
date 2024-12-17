import 'package:flutter/foundation.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/cached_web_service.dart';
import 'package:ordering_app/features/home/data/models/home_banner_model.dart';

abstract interface class HomeRemoteDataSource {
  /// Fetches featured product IDs
  Future<List<int>> getFeaturedProducts();

  /// Fetches home banner list
  Future<List<HomeBannerModel>> getHomeBanners();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final CachedWebService _webService;

  const HomeRemoteDataSourceImpl({required CachedWebService webService})
      : _webService = webService;

  @override
  Future<List<int>> getFeaturedProducts() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.featured,
        cacheDuration: const Duration(minutes: 10),
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['products'] is List) {
        return List<int>.from(response.data['products']);
      }

      return [];
    } catch (error, stackTrace) {
      _logError('Get Featured Products', error.toString(), stackTrace);
      throw AppException(error.toString());
    }
  }

  @override
  Future<List<HomeBannerModel>> getHomeBanners() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.banner,
        cacheDuration: const Duration(minutes: 10),
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['slideshows'] is List) {
        return (response.data['slideshows'] as List)
            .map((item) => HomeBannerModel.fromMap(item))
            .toList();
      }

      return [];
    } catch (error, stackTrace) {
      _logError('Get Home Banners', error.toString(), stackTrace);
      throw AppException(error.toString());
    }
  }

  /// Helper method for consistent error logging
  void _logError(String method, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint('Error during $method: $error');
      debugPrint('Stack trace: $stackTrace');
    }
  }
}
