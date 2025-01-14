import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/checkout/data/models/checkout_summary_model.dart';

abstract interface class CartRemoteDataSource {
  Future<CartSummaryModel> getCart();
  Future<String> updateCartItem({
    required int cartId,
    required int quantity,
  });

  Future<String> removeItem({
    required int cartId,
  });
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final WebService _webService;

  CartRemoteDataSourceImpl({required WebService webService})
      : _webService = webService;

  @override
  Future<CartSummaryModel> getCart() async {
    try {
      final response = await _webService.get(endpoint: Urls.getCartSummary);

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data is Map) {
        return CartSummaryModel.fromMap(response.data);
            
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> updateCartItem({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final response = await _webService.post(
        endpoint: Urls.updateCart,
        body: {
          'cart_id': cartId.toString(),
          'quantity': quantity.toString(),
        },
      );

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
  
  @override
  Future<String> removeItem({required int cartId}) async{
   try {
      final response = await _webService.post(
        endpoint: Urls.deleteCart,
        body: {
          'cart_id': cartId.toString(),
        },
      );

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
