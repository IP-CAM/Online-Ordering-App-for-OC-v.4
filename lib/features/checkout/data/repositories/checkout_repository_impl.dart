import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/exceptions.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/checkout/data/data_sources/checkout_remote_data_source.dart';
import 'package:ordering_app/features/checkout/data/models/checkout_summary_model.dart';
import 'package:ordering_app/features/checkout/data/models/payment_method_model.dart';
import 'package:ordering_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:ordering_app/features/checkout/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource _checkoutRemoteDataSource;

  CheckoutRepositoryImpl(
      {required CheckoutRemoteDataSource checkoutRemoteDataSource})
      : _checkoutRemoteDataSource = checkoutRemoteDataSource;
  @override
  Future<Either<Failure, String>> confirm({required String comment}) async {
    try {
      final res = await _checkoutRemoteDataSource.confirm(
        comment: comment,
      );

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>> paymentMethods() async {
    try {
      final res = await _checkoutRemoteDataSource.paymentMethods();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> setPaymentMethod(
      {required String code}) async {
    try {
      final res = await _checkoutRemoteDataSource.setPaymentMethod(code: code);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> setShippingAddress(
      {required int addressId}) async {
    try {
      final res = await _checkoutRemoteDataSource.setShippingAddress(
          addressId: addressId);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> setShippingMethod(
      {required String code}) async {
    try {
      final res = await _checkoutRemoteDataSource.setShippingMethod(code: code);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ShippingMethodModel>>> shippingMethods() async {
    try {
      final res = await _checkoutRemoteDataSource.shippingMethods();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, CheckoutSummaryModel>> reviewOrder() async {
    try {
      final res = await _checkoutRemoteDataSource.reviewOrder();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> applyCoupon({required String code}) async {
    try {
      final res = await _checkoutRemoteDataSource.applyCoupon(code: code);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> applyReward({required String points}) async {
    try {
      final res = await _checkoutRemoteDataSource.applyReward(points: points);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> applyVoucher({required String code}) async {
    try {
      final res = await _checkoutRemoteDataSource.applyVoucher(code: code);

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeCoupon() async {
    try {
      final res = await _checkoutRemoteDataSource.removeCoupon();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeReward() async {
    try {
      final res = await _checkoutRemoteDataSource.removeReward();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeVoucher() async {
    try {
      final res = await _checkoutRemoteDataSource.removeVoucher();

      return right(res);
    } on AppException catch (e) {
      return left(AppFailure(e.message));
    }
  }
}
