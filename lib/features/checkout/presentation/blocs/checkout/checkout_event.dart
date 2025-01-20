part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

final class ConfirmOrderEvent extends CheckoutEvent {
  final String comment;

  ConfirmOrderEvent({required this.comment});
}

final class FetchPaymentMethodsEvent extends CheckoutEvent {}

final class FetchShippingMethodsEvent extends CheckoutEvent {}


final class SetPaymentMethodEvent extends CheckoutEvent {
  final String code;

  SetPaymentMethodEvent({required this.code});
}

final class SetShippingAddressEvent extends CheckoutEvent {
  final int addressId;

  SetShippingAddressEvent({required this.addressId});
}

final class SetShippingMethodEvent extends CheckoutEvent {
  final String code;

  SetShippingMethodEvent({required this.code});
}

final class FetchSummaryEvent extends CheckoutEvent {}

final class ApplyCouponEvent extends CheckoutEvent {
  final String code;

  ApplyCouponEvent({required this.code});
}

final class ApplyRewardEvent extends CheckoutEvent {
  final String points;

  ApplyRewardEvent({required this.points});
}

final class ApplyVoucherEvent extends CheckoutEvent {
  final String code;

  ApplyVoucherEvent({required this.code});
}

final class RemoveCouponEvent extends CheckoutEvent {}
final class RemoveRewardEvent extends CheckoutEvent {}
final class RemoveVoucherEvent extends CheckoutEvent {}