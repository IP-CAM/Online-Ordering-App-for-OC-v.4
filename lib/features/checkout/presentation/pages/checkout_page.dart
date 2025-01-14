import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/checkout/domain/entities/cart_summary_entity.dart';
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
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  final _commentController = TextEditingController();
  final _couponController = TextEditingController();
  final _voucherController = TextEditingController();
  CartSummaryEntity? _summary;
  String? _appliedCoupon;
  String? _appliedVoucher;

  // Form controllers for address
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.addressId != null) {}
    _loadSummary();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _couponController.dispose();
    _voucherController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coupon applied successfully')),
    );
  }

  void _removeCoupon() {
    setState(() => _appliedCoupon = null);
    _couponController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coupon removed successfully')),
    );
  }

  void _applyVoucher() {
    if (_voucherController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a voucher code')),
      );
      return;
    }

    setState(() => _appliedVoucher = _voucherController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voucher applied successfully')),
    );
  }

  void _removeVoucher() {
    setState(() => _appliedVoucher = null);
    _voucherController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voucher removed successfully')),
    );
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
              if(state is CartFetchSuccess){
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

              if (state is CheckoutStepSuccess) {
                showCustomSnackBar(
                    context: context,
                    message: state.message,
                    type: SnackBarType.success);
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
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your city';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(labelText: 'Postal Code'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your postal code';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      isActive: _currentStep >= 1,
    );
  }

  Step _buildShippingMethodStep() {
    return Step(
      title: const Text('Shipping Method'),
      content: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Standard Shipping (5-7 business days)'),
            subtitle: const Text('\$9.99'),
            value: 'standard',
            groupValue: _summary?.shippingMethod?.shippingMethod ?? 'standard',
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _summary = CartSummaryEntity(
                    products: _summary!.products,
                    shippingAddress: _summary?.shippingAddress,
                    shippingMethod:
                        ShippingMethodEntity(shippingMethod: value, code: ''),
                    totals: _summary!.totals,
                  );
                });
              }
            },
          ),
          RadioListTile<String>(
            title: const Text('Express Shipping (2-3 business days)'),
            subtitle: const Text('\$19.99'),
            value: 'express',
            groupValue: _summary?.shippingMethod?.shippingMethod ?? 'standard',
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  _summary = CartSummaryEntity(
                    products: _summary!.products,
                    shippingAddress: _summary?.shippingAddress,
                    shippingMethod:
                        ShippingMethodEntity(code: '', shippingMethod: ''),
                    totals: _summary!.totals,
                  );
                });
              }
            },
          ),
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }

  Step _buildPaymentMethodStep() {
    return Step(
      title: const Text('Payment Method'),
      content: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Credit Card'),
            value: 'card',
            groupValue: 'card',
            onChanged: (value) {
              // Payment method selection logic
            },
          ),
          RadioListTile<String>(
            title: const Text('PayPal'),
            value: 'paypal',
            groupValue: 'card',
            onChanged: (value) {
              // Payment method selection logic
            },
          ),
          // TODO: Add payment form based on selected method
        ],
      ),
      isActive: _currentStep >= 3,
    );
  }

  Step _buildOrderConfirmationStep() {
    return Step(
      title: const Text('Confirmation'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Please review your order details before placing the order.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _commentController,
            decoration: const InputDecoration(
              labelText: 'Order Comments (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                // Create shipping address from form data
                // final shippingAddress = AddressEntity(
                //   address1: '${_firstNameController.text} ${_lastNameController.text}\n'
                //       '${_addressController.text}\n'
                //       '${_cityController.text}\n'
                //       '${_postalCodeController.text}\n'
                //       '${_phoneController.text}',
                // );

                // Update summary with shipping address
                // setState(() {
                //   _summary = CheckoutSummaryEntity(
                //     products: _summary!.products,
                //     shippingAddress: shippingAddress,
                //     shippingMethod: _summary?.shippingMethod,
                //     totals: _summary!.totals,
                //   );
                // });

                // TODO: Process the order
                debugPrint('Order placed with data: $_summary');
              }
            },
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      isActive: _currentStep >= 4,
    );
  }
}
