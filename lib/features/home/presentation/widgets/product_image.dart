// import 'package:flutter/material.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ordering_app/features/products/domain/entities/product.dart';

// class ProductImage extends StatelessWidget {
//   final Product product;

//   const ProductImage({
//     Key? key,
//     required this.product,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         // Main Product Image
//         AspectRatio(
//           aspectRatio: 1,
//           child: CachedNetworkImage(
//             imageUrl: product.image,
//             fit: BoxFit.cover,
//             placeholder: (context, url) => const Center(
//               child: CircularProgressIndicator(),
//             ),
//             errorWidget: (context, url, error) => Container(
//               color: Colors.grey[300],
//               child: const Icon(Icons.error),
//             ),
//           ),
//         ),

//         // Out of Stock Label
//         if (product.quantity <= 0)
//           Positioned(
//             top: 8,
//             right: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Text(
//                 'Out of Stock',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),

//         // Discount Label
//         if (product.special != null)
//           Positioned(
//             top: 8,
//             left: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 8,
//                 vertical: 4,
//               ),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 '${(((product.price - product.special!) / product.price) * 100).round()}% OFF',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }