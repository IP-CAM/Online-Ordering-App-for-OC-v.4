import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_coupon.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_reward.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/apply_voucher.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/confirm_order.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_checkout_summary.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_payment_methods.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_shipping_methods.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_coupon.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_reward.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/remove_voucher.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_payment_method.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_shipping_address.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/set_shipping_method.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final ConfirmOrder _confirmOrder;
  final FetchPaymentMethods _fetchPaymentMethods;
  final FetchShippingMethods _fetchShippingMethods;
  final SetPaymentMethod _setPaymentMethod;
  final SetShippingAddress _setShippingAddress;
  final SetShippingMethod _setShippingMethod;
  final FetchCheckoutSummary _fetchCheckoutSummary;
  final ApplyCoupon _applyCoupon;
  final ApplyReward _applyReward;
  final ApplyVoucher _applyVoucher;
  final RemoveCoupon _removeCoupon;
  final RemoveReward _removeReward;
  final RemoveVoucher _removeVoucher;

  CheckoutBloc({
    required ConfirmOrder confirmOrder,
    required FetchPaymentMethods fetchPaymentMethods,
    required FetchShippingMethods fetchShippingMethods,
    required SetPaymentMethod setPaymentMethod,
    required SetShippingAddress setShippingAddress,
    required SetShippingMethod setShippingMethod,
    required FetchCheckoutSummary fetchCheckoutSummary,
    required ApplyCoupon applyCoupon,
    required ApplyReward applyReward,
    required ApplyVoucher applyVoucher,
    required RemoveCoupon removeCoupon,
    required RemoveReward removeReward,
    required RemoveVoucher removeVoucher,
  })  : _confirmOrder = confirmOrder,
        _fetchPaymentMethods = fetchPaymentMethods,
        _fetchShippingMethods = fetchShippingMethods,
        _setPaymentMethod = setPaymentMethod,
        _setShippingAddress = setShippingAddress,
        _setShippingMethod = setShippingMethod,
        _fetchCheckoutSummary = fetchCheckoutSummary,
        _applyCoupon = applyCoupon,
        _applyReward = applyReward,
        _applyVoucher = applyVoucher,
        _removeCoupon = removeCoupon,
        _removeReward = removeReward,
        _removeVoucher = removeVoucher,
        super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {
      emit(CheckoutLoading());
    });
    on<ConfirmOrderEvent>(_onConfirmOrderEvent);
    on<FetchPaymentMethodsEvent>(_onFetchPaymentMethodsEvent);
    on<FetchShippingMethodsEvent>(_onFetchShippingMethodsEvent);
    on<SetPaymentMethodEvent>(_onSetPaymentMethodEvent);
    on<SetShippingAddressEvent>(_onSetShippingAddressEvent);
    on<SetShippingMethodEvent>(_onSetShippingMethodEvent);
    on<FetchSummaryEvent>(_onFetchSummaryEvent);
    on<ApplyCouponEvent>(_onApplyCouponEvent);
    on<ApplyRewardEvent>(_onApplyRewardEvent);
    on<ApplyVoucherEvent>(_onApplyVoucherEvent);
    on<RemoveCouponEvent>(_onRemoveCouponEvent);
    on<RemoveRewardEvent>(_onRemoveRewardEvent);
    on<RemoveVoucherEvent>(_onRemoveVoucherEvent);
  }

  void _onConfirmOrderEvent(
    ConfirmOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res = await _confirmOrder(ConfirmOrderParams(comment: event.comment));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(ConfirmOrderSuccess(orderId: r)),
    );
  }

  void _onFetchPaymentMethodsEvent(
    FetchPaymentMethodsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res = await _fetchPaymentMethods(NoParams());

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(FetchPaymentMethodsSuccess(paymentMethods: r)),
    );
  }

  void _onFetchShippingMethodsEvent(
    FetchShippingMethodsEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res = await _fetchShippingMethods(NoParams());

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(FetchShippingMethodsSuccess(shippingMethods: r)),
    );
  }

  void _onSetPaymentMethodEvent(
    SetPaymentMethodEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res =
        await _setPaymentMethod(SetPaymentMethodParams(code: event.code));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(SetPaymentMethodSuccess(message: r)),
    );
  }

  void _onSetShippingAddressEvent(
    SetShippingAddressEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res = await _setShippingAddress(
        SetShippingAddressParams(addressId: event.addressId));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(SetShippingAddressSuccess(message: r)),
    );
  }

  void _onSetShippingMethodEvent(
    SetShippingMethodEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res =
        await _setShippingMethod(SetShippingMethodParams(code: event.code));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(SetShippingMethodSuccess(message: r)),
    );
  }

  void _onFetchSummaryEvent(
      FetchSummaryEvent event, Emitter<CheckoutState> emit) async {
    final res = await _fetchCheckoutSummary(NoParams());

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(FetchSummarySuccess(summary: r)),
    );
  }

  void _onApplyCouponEvent(
      ApplyCouponEvent event, Emitter<CheckoutState> emit) async {
    final res = await _applyCoupon(ApplyCouponParams(code: event.code));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(CouponSuccess(message: r)),
    );
  }

  void _onApplyRewardEvent(
      ApplyRewardEvent event, Emitter<CheckoutState> emit) async {
    final res = await _applyReward(ApplyRewardParams(points: event.points));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(RewardSuccess(message: r)),
    );
  }

  void _onApplyVoucherEvent(
      ApplyVoucherEvent event, Emitter<CheckoutState> emit) async {
    final res = await _applyVoucher(ApplyVoucherParams(code: event.code));

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(VoucherSuccess(message: r)),
    );
  }

  void _onRemoveCouponEvent(
      RemoveCouponEvent event, Emitter<CheckoutState> emit) async {
    final res = await _removeCoupon(NoParams());

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(RemoveTotalsSuccess(message: r)),
    );
  }

  void _onRemoveRewardEvent(
      RemoveRewardEvent event, Emitter<CheckoutState> emit) async {
    final res = await _removeReward(NoParams());
    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(RemoveTotalsSuccess(message: r)),
    );
  }

  void _onRemoveVoucherEvent(
      RemoveVoucherEvent event, Emitter<CheckoutState> emit) async {
    final res = await _removeVoucher(NoParams());
    res.fold((l) => emit(CheckoutFailure(error: l.message)),
        (r) => emit(RemoveTotalsSuccess(message: r)));
  }
}
