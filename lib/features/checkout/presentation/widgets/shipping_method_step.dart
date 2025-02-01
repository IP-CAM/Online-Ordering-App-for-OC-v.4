import 'package:flutter/material.dart';
import 'package:ordering_app/features/checkout/domain/entities/shipping_method_entity.dart';

class ShippingMethodStep extends Step {
  ShippingMethodStep({
    required List<ShippingMethodEntity> shippingMethods,
    required ShippingMethodEntity? selectedShipping,
    required Function(ShippingMethodEntity) onShippingChanged,
    required int currentStep,
  }) : super(
          title: const Text('Shipping Method'),
          content: _ShippingMethodContent(
            shippingMethods: shippingMethods,
            selectedShipping: selectedShipping,
            onShippingChanged: onShippingChanged,
          ),
          isActive: currentStep >= 2,
        );
}

class _ShippingMethodContent extends StatelessWidget {
  final List<ShippingMethodEntity> shippingMethods;
  final ShippingMethodEntity? selectedShipping;
  final Function(ShippingMethodEntity) onShippingChanged;

  const _ShippingMethodContent({
    required this.shippingMethods,
    required this.selectedShipping,
    required this.onShippingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: shippingMethods.map((shippingMethod) {
        return RadioListTile<String>(
          title: Text(shippingMethod.shippingMethod),
          value: shippingMethod.code,
          groupValue: selectedShipping?.code,
          onChanged: (value) {
            if (value != null) {
              onShippingChanged(shippingMethod);
            }
          },
        );
      }).toList(),
    );
  }
}