import 'package:flutter/material.dart';

class ShippingAddressStep extends Step {
  const ShippingAddressStep({
    required int currentStep,
  }) : super(
          title: const Text('Shipping Address'),
          content: const SizedBox(),
          isActive: currentStep >= 1,
        );
}