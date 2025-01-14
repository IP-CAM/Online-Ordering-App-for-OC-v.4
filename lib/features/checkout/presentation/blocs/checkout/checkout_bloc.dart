import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/confirm_order.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_payment_methods.dart';
import 'package:ordering_app/features/checkout/domain/use_cases/fetch_shipping_methods.dart';
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

  CheckoutBloc({
    required ConfirmOrder confirmOrder,
    required FetchPaymentMethods fetchPaymentMethods,
    required FetchShippingMethods fetchShippingMethods,
    required SetPaymentMethod setPaymentMethod,
    required SetShippingAddress setShippingAddress,
    required SetShippingMethod setShippingMethod,
  })  : _confirmOrder = confirmOrder,
        _fetchPaymentMethods = fetchPaymentMethods,
        _fetchShippingMethods = fetchShippingMethods,
        _setPaymentMethod = setPaymentMethod,
        _setShippingAddress = setShippingAddress,
        _setShippingMethod = setShippingMethod,
        super(CheckoutInitial()) {
    on<ConfirmOrderEvent>(_onConfirmOrderEvent);
    on<FetchPaymentMethodsEvent>(_onFetchPaymentMethodsEvent);
    on<FetchShippingMethodsEvent>(_onFetchShippingMethodsEvent);
    on<SetPaymentMethodEvent>(_onSetPaymentMethodEvent);
    on<SetShippingAddressEvent>(_onSetShippingAddressEvent);
    on<SetShippingMethodEvent>(_onSetShippingMethodEvent);
  }

  void _onConfirmOrderEvent(
    ConfirmOrderEvent event,
    Emitter<CheckoutState> emit,
  ) async {
    final res = await _confirmOrder(NoParams());

    res.fold(
      (l) => emit(CheckoutFailure(error: l.message)),
      (r) => emit(ConfirmOrderSuccess(message: r)),
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
      (r) => emit(CheckoutStepSuccess(message: r)),
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
      (r) => emit(CheckoutStepSuccess(message: r)),
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
      (r) => emit(CheckoutStepSuccess(message: r)),
    );
  }
}
