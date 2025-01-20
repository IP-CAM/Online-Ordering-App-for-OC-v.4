part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutFailure extends CheckoutState {
  final String error;

  CheckoutFailure({required this.error});
}

final class SetShippingAddressSuccess extends CheckoutState {
  final String message;

  SetShippingAddressSuccess({required this.message});
}

final class SetShippingMethodSuccess extends CheckoutState {
  final String message;

  SetShippingMethodSuccess({required this.message});
}

final class SetPaymentMethodSuccess extends CheckoutState {
  final String message;

  SetPaymentMethodSuccess({required this.message});
}

final class ConfirmOrderSuccess extends CheckoutState {
  final String orderId;

  ConfirmOrderSuccess({required this.orderId});
}

final class FetchPaymentMethodsSuccess extends CheckoutState {
  final List<PaymentMethodEntity> paymentMethods;

  FetchPaymentMethodsSuccess({required this.paymentMethods});
}

final class FetchShippingMethodsSuccess extends CheckoutState {
  final List<ShippingMethodEntity> shippingMethods;

  FetchShippingMethodsSuccess({required this.shippingMethods});
}

final class FetchSummarySuccess extends CheckoutState {
  final CheckoutSummaryEntity summary;

  FetchSummarySuccess({required this.summary});
}

final class RewardSuccess extends CheckoutState {
  final String message;

  RewardSuccess({required this.message});
}

final class VoucherSuccess extends CheckoutState {
  final String message;

  VoucherSuccess({required this.message});
}

final class CouponSuccess extends CheckoutState {
  final String message;

  CouponSuccess({required this.message});
}

final class RemoveTotalsSuccess extends CheckoutState {
  final String message;

  RemoveTotalsSuccess({required this.message});
}
