import 'package:flutter/material.dart';
import 'package:ordering_app/features/products/domain/entities/product.dart';
import 'package:ordering_app/features/products/presentation/widgets/product_image.dart';
import 'package:ordering_app/features/products/presentation/widgets/product_details.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final double? width;
  final bool showAddToCart;

  const ProductCard({
    Key? key,
    required this.product,
    this.onTap,
    this.width,
    this.showAddToCart = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Section
            ProductImage(product: product),

            // Product Details Section
            Expanded(
              child: ProductDetails(
                product: product,
                showAddToCart: showAddToCart,
              ),
            ),
          ],
        ),
      ),
    );
  }
}