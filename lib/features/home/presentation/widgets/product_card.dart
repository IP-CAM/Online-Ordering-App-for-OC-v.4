import 'package:flutter/material.dart';
import 'package:ordering_app/core/common/entities/product_entity.dart';
import 'package:ordering_app/features/home/presentation/widgets/product_details.dart';
import 'package:ordering_app/features/home/presentation/widgets/product_image.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  final double? width;
  final bool showAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.width,
    this.showAddToCart = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(product: product),
              Expanded(
                child: ProductDetails(
                  product: product,
                  showAddToCart: showAddToCart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
