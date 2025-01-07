import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';

class ProductPrice extends StatelessWidget {
  final ProductEntity product;

  const ProductPrice({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle regularPriceStyle = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final TextStyle specialPriceStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final TextStyle oldPriceStyle = TextStyle(
      decoration: TextDecoration.lineThrough,
      color: Colors.grey[600],
      fontSize: 14,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.special != null) ...[
          Row(
            children: [
              Text(
                '\$${product.special!.toStringAsFixed(2)}',
                style: specialPriceStyle,
              ),
              const SizedBox(width: 8),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: oldPriceStyle,
              ),
            ],
          ),
        ] else
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: regularPriceStyle,
          ),
      ],
    );
  }
}