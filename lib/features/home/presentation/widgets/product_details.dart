// import 'package:flutter/material.dart';
// import 'package:ordering_app/features/products/domain/entities/product.dart';
// import 'package:ordering_app/core/utils/currency_formatter.dart';
// import 'package:ordering_app/features/products/presentation/widgets/product_price.dart';
// import 'package:ordering_app/features/products/presentation/widgets/add_to_cart_button.dart';

// class ProductDetails extends StatelessWidget {
//   final Product product;
//   final bool showAddToCart;

//   const ProductDetails({
//     Key? key,
//     required this.product,
//     required this.showAddToCart,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Product Name
//           Text(
//             product.name,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),

//           const Spacer(),

//           // Price Section
//           ProductPrice(product: product),

//           if (showAddToCart) ...[
//             const SizedBox(height: 8),
//             // Add to Cart Button
//             SizedBox(
//               width: double.infinity,
//               child: AddToCartButton(product: product),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }