import 'package:flutter/material.dart';
import 'package:ordering_app/core/constants/urls.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/utils/web_service.dart';
import 'package:ordering_app/features/checkout/data/models/checkout_summary_model.dart';
import 'package:ordering_app/features/checkout/data/models/payment_method_model.dart';
import 'package:ordering_app/features/checkout/data/models/shipping_method_model.dart';

abstract interface class CheckoutRemoteDataSource {
  Future<String> confirm({
    required String comment,
  });
  Future<List<ShippingMethodModel>> shippingMethods();
  Future<List<PaymentMethodModel>> paymentMethods();

  Future<String> setShippingAddress({
    required int addressId,
  });
  Future<String> setShippingMethod({required String code});
  Future<String> setPaymentMethod({required String code});
  Future<CheckoutSummaryModel> reviewOrder();
  Future<String> applyCoupon({required String code});
  Future<String> applyReward({required String points});
  Future<String> applyVoucher({required String code});
  Future<String> removeVoucher();
  Future<String> removeReward();
  Future<String> removeCoupon();
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final WebService _webService;

  CheckoutRemoteDataSourceImpl({required WebService webService})
      : _webService = webService;

  @override
  Future<String> confirm({
    required String comment,
  }) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.confirmOrder, body: {
        'comment': comment,
      });

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data is Map) {
        return response.data['order_id'] is int
            ? response.data['order_id'].toString()
            : response.data['order_id'] as String;
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<List<PaymentMethodModel>> paymentMethods() async {
    try {
      final response =
          await _webService.get(endpoint: Urls.fetchPaymentMethods);

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }

      // Explicit type casting and null check
      if (response.success && response.data['payment_methods'] is List) {
        return (response.data['payment_methods'] as List)
            .map((item) => PaymentMethodModel.fromMap(item))
            .toList();
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> setPaymentMethod({required String code}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.setPaymentMethod, body: {
        'payment_code': code,
      });

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
  Future<String> setShippingAddress({required int addressId}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.setShippingAddress, body: {
        'address_id': addressId,
      });

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
  Future<String> setShippingMethod({required String code}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.setShippingMethod, body: {
        'shipping_code': code,
      });

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
  Future<List<ShippingMethodModel>> shippingMethods() async {
    try {
      final response = await _webService.get(endpoint: Urls.getShippingMethods);

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }
      // Explicit type casting and null check
      if (response.success && response.data['shipping_methods'] is List) {
        return (response.data['shipping_methods'] as List)
            .map((item) => ShippingMethodModel.fromMap(item))
            .toList();
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<CheckoutSummaryModel> reviewOrder() async {
    try {
      final response = await _webService.get(endpoint: Urls.reviewOrder);

      // Early return if there's an error
      if (response.error != null) {
        throw response.error!;
      }
      // Explicit type casting and null check
      if (response.success && response.data['order_review'] is Map) {
        return CheckoutSummaryModel.fromMap(response.data['order_review']);
      }

      throw 'Unknown error';
    } catch (e, s) {
      debugPrint(s.toString());
      throw AppException(e.toString());
    }
  }

  @override
  Future<String> applyCoupon({required String code}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.applyCoupon, body: {
        'coupon': code,
      });

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
  Future<String> applyReward({required String points}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.applyReward, body: {
        'points': points,
      });

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
  Future<String> removeCoupon() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.removeCoupon,
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
  Future<String> removeReward() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.removeReward,
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
  Future<String> applyVoucher({required String code}) async {
    try {
      final response =
          await _webService.post(endpoint: Urls.applyVoucher, body: {
        'voucher': code,
      });

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
  Future<String> removeVoucher() async {
    try {
      final response = await _webService.get(
        endpoint: Urls.removeVoucher,
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
