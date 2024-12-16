// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ordering_app/features/home/presentation/bloc/featured_products_bloc.dart';
// import 'package:ordering_app/features/products/presentation/widgets/product_card.dart';

// class FeaturedProducts extends StatelessWidget {
//   const FeaturedProducts({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FeaturedProductsBloc, FeaturedProductsState>(
//       builder: (context, state) {
//         if (state is FeaturedProductsLoading) {
//           return const SizedBox(
//             height: 200,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state is FeaturedProductsLoaded && state.products.isNotEmpty) {
//           return SizedBox(
//             height: 280,
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               scrollDirection: Axis.horizontal,
//               itemCount: state.products.length,
//               itemBuilder: (context, index) {
//                 final product = state.products[index];
//                 return Container(
//                   width: 180,
//                   margin: const EdgeInsets.only(right: 16),
//                   child: ProductCard(
//                     product: product,
//                     onTap: () {
//                       // Navigate to product details
//                       // NavigationService.push(
//                       //   context,
//                       //   RouteConstants.productDetails,
//                       //   arguments: product,
//                       // );
//                     },
//                   ),
//                 );
//               },
//             ),
//           );
//         }

//         return const SizedBox();
//       },
//     );
//   }
// }