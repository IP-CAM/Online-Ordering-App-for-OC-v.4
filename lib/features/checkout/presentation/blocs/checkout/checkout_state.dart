part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutFailure extends CheckoutState {
  final String error;

  CheckoutFailure({required this.error});
}

final class CheckoutStepSuccess extends CheckoutState {
  final String message;

  CheckoutStepSuccess({required this.message});
}

final class ConfirmOrderSuccess extends CheckoutState {
  final String message;

  ConfirmOrderSuccess({required this.message});
}

final class FetchPaymentMethodsSuccess extends CheckoutState {
  final List<PaymentMethodEntity> paymentMethods;

  FetchPaymentMethodsSuccess({required this.paymentMethods});
}

final class FetchShippingMethodsSuccess extends CheckoutState {
  final List<ShippingMethodEntity> shippingMethods;

  FetchShippingMethodsSuccess({required this.shippingMethods});
}
