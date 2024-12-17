// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ordering_app/core/common/entities/product_entity.dart';


// class AddToCartButton extends StatelessWidget {
//   final ProductEntity product;

//   const AddToCartButton({
//     super.key,
//     required this.product,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CartBloc, CartState>(
//       buildWhen: (previous, current) => 
//         previous.getQuantity(product.productId) != current.getQuantity(product.productId),
//       builder: (context, state) {
//         final quantity = state.getQuantity(product.productId);

//         if (quantity == 0) {
//           return ElevatedButton(
//             onPressed: product.quantity > 0
//                 ? () => context.read<CartBloc>().add(
//                       AddToCartEvent(
//                         productId: product.productId,
//                         quantity: 1,
//                       ),
//                     )
//                 : null,
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//             ),
//             child: const Text('Add to Cart'),
//           );
//         }

//         return Container(
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             borderRadius: BorderRadius.circular(4),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Decrease Button
//               IconButton(
//                 onPressed: () => context.read<CartBloc>().add(
//                       RemoveFromCartEvent(
//                         productId: product.productId,
//                         quantity: 1,
//                       ),
//                     ),
//                 icon: const Icon(Icons.remove),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//               // Quantity
//               Text(
//                 quantity.toString(),
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               // Increase Button
//               IconButton(
//                 onPressed: quantity < product.quantity
//                     ? () => context.read<CartBloc>().add(
//                           AddToCartEvent(
//                             productId: product.productId,
//                             quantity: 1,
//                           ),
//                         )
//                     : null,
//                 icon: const Icon(Icons.add),
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }