import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/route_constants.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/dependencies/dependencies.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_images_carousel.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_options_selector.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';

class ProductViewPage extends StatefulWidget {
  final ProductEntity product;

  const ProductViewPage({
    super.key,
    required this.product,
  });

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  final Map<String, List<String>> selectedOptions = {};
  int quantity = 1;

  void _updateSelectedOption(String optionId, List<String> values) {
    setState(() {
      selectedOptions[optionId] = values;
    });
  }

  void _updateQuantity(int value) {
    setState(() {
      quantity = value.clamp(widget.product.minimum, 999);
    });
  }

  Map<String, String> _handleCartData() {
    // Initialize request data
    final Map<String, String> requestData = {
      'product_id': widget.product.productId.toString(),
      'quantity': quantity.toString(),
    };

    // Process options if they exist and are selected
    if (widget.product.options.isNotEmpty && selectedOptions.isNotEmpty) {
      final Map<String, dynamic> optionData = {};

      for (var option in widget.product.options) {
        final String optionId = option.productOptionId.toString();

        if (selectedOptions.containsKey(optionId) && 
            selectedOptions[optionId]!.isNotEmpty) {
          switch (option.type) {
            case 'select':
            case 'radio':
              optionData[optionId] = selectedOptions[optionId]!.first;
              break;

            case 'checkbox':
              optionData[optionId] = selectedOptions[optionId]!;
              break;

            case 'text':
            case 'textarea':
              optionData[optionId] = selectedOptions[optionId]!.first;
              break;

            case 'date':
              optionData[optionId] = selectedOptions[optionId]!.first;
              break;

            case 'time':
              // Handle time string directly without parsing
              final timeStr = selectedOptions[optionId]!.first;
              // Validate time format (HH:mm)
              if (RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$').hasMatch(timeStr)) {
                // Format to ensure HH:mm
                final parts = timeStr.split(':');
                final hour = int.parse(parts[0]).toString().padLeft(2, '0');
                final minute = parts[1].padLeft(2, '0');
                optionData[optionId] = '$hour:$minute';
              } else {
                throw Exception('Invalid time format. Please use HH:mm format');
              }
              break;

            case 'datetime':
              optionData[optionId] = selectedOptions[optionId]!.first;
              break;
          }
        }
      }

      // Add options to request if any were processed
      if (optionData.isNotEmpty) {
        final String jsonString = jsonEncode(optionData);
        requestData['option'] = jsonString;
      }
    }

    return requestData;
}

  List<String> _validateRequiredOptions() {
    final List<String> missingOptions = [];

    for (var option in widget.product.options) {
      if (option.required == '1') {
        // Check if option is selected
        if (!selectedOptions.containsKey(option.productOptionId) ||
            selectedOptions[option.productOptionId]!.isEmpty) {
          missingOptions.add(option.name);
        }
        // For file type, might want to add additional validation
        else if (option.type == 'file') {
          final value = selectedOptions[option.productOptionId]!.first;
          if (value.isEmpty) {
            missingOptions.add(option.name);
          }
        }
      }
    }

    return missingOptions;
  }

  void _handleAddToCart() {
    final authState = serviceLocator<AuthCubit>().state;

    if (authState is AuthInitial) {
      showCustomSnackBar(
        context: context,
        message: "Login to add items to cart!",
        type: SnackBarType.warning,
      );

      NavigationService.push(context, RouteConstants.login);
      return;
    }

    // Validate required options
    final missingOptions = _validateRequiredOptions();

    if (missingOptions.isNotEmpty) {
      showCustomSnackBar(
        context: context,
        message: 'Please select: ${missingOptions.join(", ")}',
        type: SnackBarType.error,
      );
      return;
    }

    // Prepare cart data
    final cartData = _handleCartData();

    BlocProvider.of<MenuBloc>(context).add(AddToCartEvent(cartData: cartData));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImagesCarousel(
              mainImage: widget.product.image,
              additionalImages: widget.product.additionalImages,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  if (widget.product.sku.isNotEmpty) ...[
                    Text(
                      'SKU: ${widget.product.sku}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(
                    children: [
                      if (widget.product.special != null) ...[
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '\$${widget.product.special!.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: theme.textTheme.titleLarge,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stock Status: ${widget.product.stockStatus}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  if (widget.product.options.isNotEmpty) ...[
                    ProductOptionsSelector(
                      options: widget.product.options,
                      selectedOptions: selectedOptions,
                      onOptionSelected: _updateSelectedOption,
                    ),
                    const SizedBox(height: 24),
                  ],
                  Row(
                    children: [
                      Text('Quantity:', style: theme.textTheme.titleMedium),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          IconButton(
                            onPressed: quantity > widget.product.minimum
                                ? () => _updateQuantity(quantity - 1)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              controller: TextEditingController(
                                text: quantity.toString(),
                              ),
                              onChanged: (value) {
                                final newValue = int.tryParse(value) ??
                                    widget.product.minimum;
                                _updateQuantity(newValue);
                              },
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(quantity + 1),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: BlocConsumer<MenuBloc, MenuState>(
                      listener: (context, state) {
                        if (state is MenuLoading) {
                          Loader.show(context);
                        } else {
                          Loader.hide();
                        }

                        if (state is AddToCartSuccess) {
                          showCustomSnackBar(
                              context: context,
                              message:( decodeHtmlEntities(state.message)),
                              type: SnackBarType.success);
                          NavigationService.pop(context);
                        }

                        if (state is MenuFailure) {
                          showCustomSnackBar(
                              context: context,
                              message: decodeHtmlEntities(state.error),
                              type: SnackBarType.error);
                        }
                      },
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: widget.product.quantity > 0
                              ? _handleAddToCart
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Add to Cart'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Description',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
