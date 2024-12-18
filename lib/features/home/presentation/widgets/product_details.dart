import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/home/presentation/widgets/product_price.dart';

class ProductDetails extends StatelessWidget {
  final ProductEntity product;
  final bool showAddToCart;

  const ProductDetails({
    super.key,
    required this.product,
    required this.showAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          ProductPrice(product: product),
          if (showAddToCart) ...[
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: product.quantity > 0 ? () {
                  showCustomSnackBar(context: context, message: "${product.name} added to cart",type: SnackBarType.success,);
                } : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart, size: 20),
                label: const Text('Add to Cart'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}