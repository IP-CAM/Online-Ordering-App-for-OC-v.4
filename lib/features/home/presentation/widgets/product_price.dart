// import 'package:flutter/material.dart';
// import 'package:ordering_app/features/products/domain/entities/product.dart';
// import 'package:ordering_app/core/utils/currency_formatter.dart';

// class ProductPrice extends StatelessWidget {
//   final Product product;

//   const ProductPrice({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         // Special Price
//         if (product.special != null) ...[
//           Text(
//             formatCurrency(product.special!),
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(width: 4),
//           Text(
//             formatCurrency(product.price),
//             style: const TextStyle(
//               decoration: TextDecoration.lineThrough,
//               color: Colors.grey,
//               fontSize: 12,
//             ),
//           ),
//         ] else
//           Text(
//             formatCurrency(product.price),
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//       ],
//     );
//   }
// }