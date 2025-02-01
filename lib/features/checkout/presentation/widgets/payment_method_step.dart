import 'package:flutter/material.dart';
import 'package:ordering_app/features/checkout/domain/entities/payment_method_entity.dart';

class PaymentMethodStep extends Step {
  PaymentMethodStep({
    required List<PaymentMethodEntity> paymentMethods,
    required PaymentMethodEntity? selectedPayment,
    required Function(PaymentMethodEntity) onPaymentChanged,
    required int currentStep,
  }) : super(
          title: const Text('Payment Method'),
          content: _PaymentMethodContent(
            paymentMethods: paymentMethods,
            selectedPayment: selectedPayment,
            onPaymentChanged: onPaymentChanged,
          ),
          isActive: currentStep >= 3,
        );
}

class _PaymentMethodContent extends StatelessWidget {
  final List<PaymentMethodEntity> paymentMethods;
  final PaymentMethodEntity? selectedPayment;
  final Function(PaymentMethodEntity) onPaymentChanged;

  const _PaymentMethodContent({
    required this.paymentMethods,
    required this.selectedPayment,
    required this.onPaymentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: paymentMethods.map((paymentMethod) {
        return RadioListTile<String>(
          title: Text(paymentMethod.title),
          value: paymentMethod.code,
          groupValue: selectedPayment?.code,
          onChanged: (value) {
            if (value != null) {
              onPaymentChanged(paymentMethod);
            }
          },
        );
      }).toList(),
    );
  }
}