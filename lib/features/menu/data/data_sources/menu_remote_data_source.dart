import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';

abstract interface class MenuRemoteDataSource {
  Future<String> addToCart({
    required Map<String, dynamic> cartData,
  });
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final WebService _webService;

  MenuRemoteDataSourceImpl({required WebService webService})
      : _webService = webService;

  @override
  Future<String> addToCart({required Map<String, dynamic> cartData}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.addToCart, body: cartData);

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data is Map) {
        return response.data['success'] as String;
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }
}
