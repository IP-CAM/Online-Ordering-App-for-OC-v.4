import 'package:ordering_app/features/address_book/domain/entities/address_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';

class CheckoutSummaryEntity {
  final CheckoutTotals checkoutTotals;
  final AddressEntity shippingAddress;
  final ShippingMethodEntity shippingMethod;
  final PaymentMethodEntity paymentMethod;

  CheckoutSummaryEntity({
    required this.checkoutTotals,
    required this.shippingAddress,
    required this.shippingMethod,
    required this.paymentMethod,
  });
}

class CheckoutTotals {
  final String subTotal;
  final String total;
  final List<AppliedTotalEntity> appliedTotals;
  final List<TaxEntity> taxes;

  CheckoutTotals({
    required this.subTotal,
    required this.total,
    required this.appliedTotals,
    required this.taxes,
  });


}

class TaxEntity {
  final String code;
  final String title;
  final double value;
  final int sortOrder;

  const TaxEntity({
    required this.code,
    required this.title,
    required this.value,
    required this.sortOrder,
  });
}

class AppliedTotalEntity {
  final String title;
  final String value;

  AppliedTotalEntity({
    required this.title,
    required this.value,
  });
}
