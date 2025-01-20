import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/checkout_summary_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/checkout/checkout_bloc.dart';
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
  final _couponController = TextEditingController();
  final _voucherController = TextEditingController();
  CartSummaryEntity? _summary;
  String? _appliedCoupon;
  String? _appliedVoucher;

  List<ShippingMethodEntity> _shippingMethods = [];
  ShippingMethodEntity? _selectedShipping;

  List<PaymentMethodEntity> _paymentMethods = [];

  PaymentMethodEntity? _selectedPayment;

  CheckoutSummaryEntity? _checkoutSummary;

  void _updateAddress() {
    debugPrint('Address id: ${widget.addressId}');
    BlocProvider.of<CheckoutBloc>(context)
        .add(SetShippingAddressEvent(addressId: widget.addressId!));
    setState(() {
      _currentStep = 2;
    });
  }

  void _fetchReviewData() {
    BlocProvider.of<CheckoutBloc>(context).add(FetchSummaryEvent());
  }

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {
      _updateAddress();
    }
    _loadSummary();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _couponController.dispose();
    _voucherController.dispose();
    super.dispose();
  }

  void _setShipping() {
    if (_selectedShipping != null) {
      BlocProvider.of<CheckoutBloc>(context).add(
        SetShippingMethodEvent(code: _selectedShipping!.code),
      );
    }
  }

  void _setPayment() {
    debugPrint('Payment: ${_selectedPayment?.title.toString()}');
    if (_selectedPayment != null) {
      BlocProvider.of<CheckoutBloc>(context)
          .add(SetPaymentMethodEvent(code: _selectedPayment!.code));
    }
  }

  Future<void> _loadSummary() async {
    BlocProvider.of<CartBloc>(context).add(CartFetchEvent());
  }

  void _applyCoupon() {
    if (_couponController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    setState(() => _appliedCoupon = _couponController.text);
    BlocProvider.of<CheckoutBloc>(context).add(ApplyCouponEvent(
      code: _couponController.text,
    ));
  }

  void _removeCoupon() {
    setState(() => _appliedCoupon = null);
    _couponController.clear();

    BlocProvider.of<CheckoutBloc>(context).add(RemoveCouponEvent());
  }

  void _applyVoucher() {
    if (_voucherController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a voucher code')),
      );
      return;
    }

    setState(() => _appliedVoucher = _voucherController.text);
    BlocProvider.of<CheckoutBloc>(context).add(ApplyVoucherEvent(code: _voucherController.text));
   
  }

  void _removeVoucher() {
    setState(() => _appliedVoucher = null);
    _voucherController.clear();
    BlocProvider.of<CheckoutBloc>(context).add(RemoveVoucherEvent());
    
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
                    type: SnackBarType.error);
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
                _fetchReviewData();
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

              if (state is CouponSuccess) {
                showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success);
                _loadSummary();
              }

              if (state is RemoveTotalsSuccess) {
                showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success);
                _loadSummary();
              }
              if (state is RewardSuccess) {
                showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success);
                _loadSummary();
              }

              if (state is VoucherSuccess) {
                showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success);
                _loadSummary();
              }
            },
          )
        ],
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
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
            _buildCartReviewStep(),
            _buildShippingAddressStep(),
            _buildShippingMethodStep(),
            _buildPaymentMethodStep(),
            _buildOrderConfirmationStep(),
          ],
        ),
      ),
      floatingActionButton: const ThemeModeFAB(),
    );
  }

  Step _buildCartReviewStep() {
    return Step(
      title: const Text('Review Cart'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCartItemsList(context),
          const Divider(height: 32),
          _buildDiscountSection(),
          const Divider(height: 32),
          _buildCartTotals(),
        ],
      ),
      isActive: _currentStep >= 0,
    );
  }

  Widget _buildCartItemsList(BuildContext context) {
    final theme = Theme.of(context);

    if (_summary == null) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _summary!.products.length,
      itemBuilder: (context, index) {
        final item = _summary!.products[index];
        return Card(
          elevation: theme.brightness == Brightness.light ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: theme.brightness == Brightness.dark
                ? BorderSide(color: theme.colorScheme.outline)
                : BorderSide.none,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item.image != null
                              ? Image.network(
                                  item.image!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: theme.colorScheme.surfaceVariant,
                                  child: Icon(
                                    Icons.image,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                decodeHtmlEntities(item.name),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.model.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.model,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (item.options != null && item.options!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Options',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...item.options!.map((option) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        decodeHtmlEntities(option.name),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme
                                              .colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        option.value,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: theme.colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Quantity: ${item.quantity}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              item.total,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            if (item.price != item.total)
                              Text(
                                '${item.price} each',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDiscountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Coupon Section
        const Text(
          'Have a Coupon?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _couponController,
                decoration: const InputDecoration(
                  hintText: 'Enter coupon code',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _appliedCoupon != null ? _removeCoupon : _applyCoupon,
              child: Text(_appliedCoupon != null ? 'Remove' : 'Apply'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Voucher Section
        const Text(
          'Have a Voucher?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _voucherController,
                decoration: const InputDecoration(
                  hintText: 'Enter voucher code',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed:
                  _appliedVoucher != null ? _removeVoucher : _applyVoucher,
              child: Text(_appliedVoucher != null ? 'Remove' : 'Apply'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCartTotals() {
    if (_summary == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ..._summary!.totals.map((total) => _buildTotalRow(
                  '${total.title}:',
                  total.value,
                  textStyle: total.title == 'Total'
                      ? const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )
                      : null,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(
    String label,
    String value, {
    TextStyle? textStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textStyle),
          Text(value, style: textStyle),
        ],
      ),
    );
  }

  Step _buildShippingAddressStep() {
    return Step(
      title: const Text('Shipping Address'),
      content: const SizedBox(),
      isActive: _currentStep >= 1,
    );
  }

  Step _buildShippingMethodStep() {
    return Step(
      title: const Text('Shipping Method'),
      content: Column(
        children: _shippingMethods
            .map(
              (shippingMethod) => RadioListTile<String>(
                title: Text(shippingMethod.shippingMethod),
                value: shippingMethod.code,
                groupValue:
                    _selectedPayment?.code ?? _shippingMethods.first.code,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _selectedShipping = shippingMethod;
                    });
                    _setShipping();
                  }
                },
              ),
            )
            .toList(),
      ),
      isActive: _currentStep >= 2,
    );
  }

  Step _buildPaymentMethodStep() {
    return Step(
      title: const Text('Payment Method'),
      content: Column(
        children: _paymentMethods
            .map(
              (paymentMethod) => RadioListTile<String>(
                title: Text(paymentMethod.title),
                value: paymentMethod.code, // Use paymentMethod.code as value
                groupValue: _selectedPayment?.code, // Match with groupValue
                onChanged: (value) {
                  if (value != null) {
                    // Should print the selected value
                    setState(() {
                      _selectedPayment = paymentMethod;
                    });
                    _setPayment();
                  }
                },
              ),
            )
            .toList(),
      ),
      isActive: _currentStep >= 3,
    );
  }

  Step _buildOrderConfirmationStep() {
    return Step(
      title: const Text('Order Confirmation'),
      content: SingleChildScrollView(
        child: Card(
          elevation: 2,
          shadowColor: Theme.of(context).colorScheme.inverseSurface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Review Order Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please verify all information before placing your order.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
                const Divider(height: 32),
                if (_checkoutSummary != null) ...[
                  _buildSectionTitle('Delivery Method'),
                  _buildInfoTile(
                    icon: Icons.local_shipping,
                    title: _checkoutSummary!.shippingMethod.shippingMethod,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Payment Method'),
                  _buildInfoTile(
                    icon: Icons.payment,
                    title: _checkoutSummary!.paymentMethod.title,
                  ),
                  const SizedBox(height: 16),
                  _buildSectionTitle('Shipping Address'),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_checkoutSummary!.shippingAddress.firstName} ${_checkoutSummary!.shippingAddress.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(_checkoutSummary!.shippingAddress.address1),
                        if (_checkoutSummary!.shippingAddress.address2 != null)
                          Text(_checkoutSummary!.shippingAddress.address2!),
                        Text(
                            '${_checkoutSummary!.shippingAddress.city}, ${_checkoutSummary!.shippingAddress.postcode}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Order Summary'),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildPriceLine(
                          'Subtotal',
                          _checkoutSummary!.checkoutTotals.subTotal,
                          isTotal: false,
                        ),
                        ..._checkoutSummary!.checkoutTotals.appliedTotals
                            .map((total) => _buildPriceLine(
                                  total.title,
                                  total.value,
                                  isTotal: false,
                                )),
                        const Divider(),
                        ..._checkoutSummary!.checkoutTotals.taxes
                            .map((tax) => _buildPriceLine(
                                  tax.title,
                                  tax.value.toString(),
                                  isTotal: false,
                                )),
                        const Divider(),
                        _buildPriceLine(
                          'Total',
                          _checkoutSummary!.checkoutTotals.total,
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    labelText: 'Order Comments (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<CheckoutBloc>(context).add(
                        ConfirmOrderEvent(comment: _commentController.text));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isActive: _currentStep >= 4,
    );
  }

// Helper widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade500),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceLine(String label, String amount, {required bool isTotal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
