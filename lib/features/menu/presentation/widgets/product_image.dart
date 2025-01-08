import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/core/utils/helpers.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/menu/presentation/widgets/product_price.dart';
import 'package:ordering_app/core/utils/image_utils.dart';

class ProductImage extends StatelessWidget {
  final ProductEntity product;

  const ProductImage({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        // Main Product Image
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: ImageUtils.buildNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                placeholderSize: 50,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),

        // Out of Stock Badge
        if (product.quantity <= 0)
          Positioned(
            top: 8,
            right: 8,
            child: _buildBadge(
              context: context,
              text: 'Out of Stock',
              backgroundColor: Colors.red.withOpacity(0.9),
            ),
          ),

        // Discount Badge
        if (_hasValidDiscount())
          Positioned(
            top: 8,
            left: 8,
            child: _buildBadge(
              context: context,
              text: '${_calculateDiscountPercentage()}% OFF',
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
          ),

        // Info Button
        if (_hasValidDescription())
          Positioned(
            top: 8,
            right: 8,
            child: _buildInfoButton(context),
          ),
      ],
    );
  }

  bool _hasValidDescription() {
    return product.description.trim().isNotEmpty;
  }

  bool _hasValidDiscount() {
    return product.special != null && 
           product.special! > 0 && 
           product.special! < product.price;
  }

  int _calculateDiscountPercentage() {
    if (!_hasValidDiscount()) return 0;
    return (((product.price - product.special!) / product.price) * 100).round();
  }

  Widget _buildBadge({
    required BuildContext context,
    required String text,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.info_outline),
        onPressed: () => _showProductDetails(context),
        iconSize: 24,
        color: Theme.of(context).colorScheme.primary,
        constraints: const BoxConstraints(
          minWidth: 32,
          minHeight: 32,
        ),
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  void _showProductDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: ImageUtils.buildNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                        placeholderSize: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Product Name
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),

                // Product Price
                ProductPrice(product: product),
                const SizedBox(height: 12),

                // Product Description
                if (_hasValidDescription())
                  Text(
                    decodeHtmlEntities(product.description),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                const SizedBox(height: 16),

                // Add to Cart Button
                if (product.quantity > 0)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showCustomSnackBar(
                          context: context,
                          message: "${product.name} added to cart",
                          type: SnackBarType.success,
                        );
                      },
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
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}