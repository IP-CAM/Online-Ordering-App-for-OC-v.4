import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/cart_review_step.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/order_confirmation_dialog.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/order_confirmation_step.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/payment_method_step.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/shipping_address_step.dart';
import 'package:ordering_app/features/checkout/presentation/widgets/shipping_method_step.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class CheckoutPage extends StatefulWidget {
  final int? addressId;

  const CheckoutPage({
    super.key,
    this.addressId,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;
  final _commentController = TextEditingController();
  CartSummaryEntity? _summary;
  bool _showProgressIndicator = false;
  List<ShippingMethodEntity> _shippingMethods = [];
  ShippingMethodEntity? _selectedShipping;
  List<PaymentMethodEntity> _paymentMethods = [];
  PaymentMethodEntity? _selectedPayment;
  CheckoutSummaryEntity? _checkoutSummary;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSummary();
      if (widget.addressId != null) {
        _updateAddress();
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateAddress() {
    debugPrint('Address id: ${widget.addressId}');
    BlocProvider.of<CheckoutBloc>(context)
        .add(SetShippingAddressEvent(addressId: widget.addressId!));
    setState(() {
      _currentStep = 2;
    });
  }

  void _setShipping() {
    if (_selectedShipping != null) {
      BlocProvider.of<CheckoutBloc>(context).add(
        SetShippingMethodEvent(code: _selectedShipping!.code),
      );
    }
  }

  void _setPayment() {
    if (_selectedPayment != null) {
      BlocProvider.of<CheckoutBloc>(context)
          .add(SetPaymentMethodEvent(code: _selectedPayment!.code));
    }
  }

  void _loadSummary() {
    BlocProvider.of<CartBloc>(context).add(CartFetchEvent());
  }

  Future<void> _loadCheckoutSummary() async {
    BlocProvider.of<CheckoutBloc>(context).add(FetchSummaryEvent());
  }

  void _placeOrder() {
    BlocProvider.of<CheckoutBloc>(context)
        .add(ConfirmOrderEvent(comment: _commentController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CartBloc, CartState>(
            listener: (context, state) {
              if (state is CartLoading) {
                setState(() {
                  _showProgressIndicator = true;
                });
                Loader.show(context);
              } else {
                setState(() {
                  _showProgressIndicator = false;
                });
                Loader.hide();
              }

              if (state is CartFetchSuccess) {
                setState(() {
                  _summary = state.cartSummary;
                });
              }
            },
          ),
          BlocListener<CheckoutBloc, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutLoading) {
                Loader.show(context);
              } else {
                Loader.hide();
              }

              if (state is CheckoutFailure) {
                showCustomSnackBar(
                  context: context,
                  message: state.error,
                  type: SnackBarType.error,
                );
              }

              if (state is SetShippingAddressSuccess) {
                BlocProvider.of<CheckoutBloc>(context)
                    .add(FetchShippingMethodsEvent());
              }

              if (state is SetShippingMethodSuccess) {
                BlocProvider.of<CheckoutBloc>(context)
                    .add(FetchPaymentMethodsEvent());
              }

              if (state is FetchShippingMethodsSuccess) {
                setState(() {
                  _shippingMethods = state.shippingMethods;
                  _selectedShipping = _shippingMethods.first;
                });
              }

              if (state is FetchPaymentMethodsSuccess) {
                setState(() {
                  _paymentMethods = state.paymentMethods;
                });
              }

              if (state is SetPaymentMethodSuccess) {
                _loadCheckoutSummary();
              }

              if (state is FetchSummarySuccess) {
                setState(() {
                  _checkoutSummary = state.summary;
                });
              }

              if (state is ConfirmOrderSuccess) {
                NavigationService.pushReplacementWithQuery(
                  context,
                  RouteConstants.orderSuccess,
                  {
                    'orderId': state.orderId,
                  },
                );
              }
            },
          ),
        ],
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 80), // Add padding for FAB
          children: [
            Stepper(
              physics:
                  const ClampingScrollPhysics(), // Prevent nested scrolling
              currentStep: _currentStep,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          onPressed: details.onStepContinue,
                          child: Text(
                            _currentStep == 4 ? 'Place Order' : 'Continue',
                          ),
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ],
                    ],
                  ),
                );
              },
              onStepContinue: () {
                if (_currentStep == 4) {
                  showDialog(
                    context: context,
                    builder: (context) => OrderConfirmationDialog(
                      checkoutSummary: _checkoutSummary,
                      onConfirm: _placeOrder,
                    ),
                  );
                  return;
                }

                if (_currentStep < 4) {
                  setState(() => _currentStep += 1);
                }

                if (_currentStep == 1) {
                  NavigationService.pushWithQuery(
                    context,
                    RouteConstants.addressBook,
                    {
                      'isOnCheckout': true,
                    },
                  );
                }

                if (_currentStep == 3) {
                  _setShipping();
                }

                if (_currentStep == 4) {
                  _setPayment();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() => _currentStep -= 1);
                }
              },
              steps: [
                CartReviewStep(
                  showProgressIndicator: _showProgressIndicator,
                  summary: _summary,
                  currentStep: _currentStep,
                ),
                ShippingAddressStep(currentStep: _currentStep),
                ShippingMethodStep(
                  shippingMethods: _shippingMethods,
                  selectedShipping: _selectedShipping,
                  onShippingChanged: (shipping) {
                    setState(() {
                      _selectedShipping = shipping;
                    });
                    _setShipping();
                  },
                  currentStep: _currentStep,
                ),
                PaymentMethodStep(
                  paymentMethods: _paymentMethods,
                  selectedPayment: _selectedPayment,
                  onPaymentChanged: (payment) {
                    setState(() {
                      _selectedPayment = payment;
                    });
                    _setPayment();
                  },
                  currentStep: _currentStep,
                ),
                OrderConfirmationStep(
                  checkoutSummary: _checkoutSummary,
                  commentController: _commentController,
                  currentStep: _currentStep,
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: const ThemeModeFAB(),
    );
  }
}
