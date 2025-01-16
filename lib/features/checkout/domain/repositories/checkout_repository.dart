import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/errors/failures.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';

abstract interface class CheckoutRepository {
  Future<Either<Failure, String>> confirm({required String comment,});
  Future<Either<Failure, List<ShippingMethodEntity>>> shippingMethods();
  Future<Either<Failure, List<PaymentMethodEntity>>> paymentMethods();
  Future<Either<Failure, String>> setShippingAddress({
    required int addressId,
  });
  Future<Either<Failure, String>> setShippingMethod({required String code});
  Future<Either<Failure, String>> setPaymentMethod({required String code});
   Future<Either<Failure,CheckoutSummaryEntity>>reviewOrder() ;
}