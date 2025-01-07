import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/cached_web_service.dart';
import 'package:ordering_app/features/about/data/models/info_model.dart';

abstract interface class AboutRemoteDataSource {
  Future<InfoModel> getInfo();
}

class AboutRemoteDataSourceImpl implements AboutRemoteDataSource {
  final CachedWebService _cachedWebService;

  AboutRemoteDataSourceImpl({required CachedWebService cachedWebService})
      : _cachedWebService = cachedWebService;
  @override
  Future<InfoModel> getInfo() async {
    try {
      final response = await _cachedWebService.get(
        endpoint: Urls.storeInfo,
        cacheDuration: const Duration(
          minutes: 10,
        ),
      );

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data is Map) {
        return InfoModel.fromMap(response.data);
      }

      throw 'Unknown error';
    } catch (error, stackTrace) {
      debugPrint(stackTrace.toString());
      throw AppException(error.toString());
    }
  }
}
