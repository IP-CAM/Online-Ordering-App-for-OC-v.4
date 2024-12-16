// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ordering_app/features/categories/presentation/bloc/categories_bloc.dart';

// class SliverCategoryChipsDelegate extends SliverPersistentHeaderDelegate {
//   const SliverCategoryChipsDelegate();

//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: const CategoryChips(),
//     );
//   }

//   @override
//   double get maxExtent => 56.0;

//   @override
//   double get minExtent => 56.0;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
// }

// class CategoryChips extends StatelessWidget {
//   const CategoryChips({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CategoriesBloc, CategoriesState>(
//       builder: (context, state) {
//         if (state is CategoriesLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
        
//         if (state is CategoriesLoaded) {
//           return SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: state.categories.map((category) {
//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8),
//                   child: ActionChip(
//                     label: Text(category.name),
//                     onPressed: () {
//                       // Navigate to category products
//                       // NavigationService.push(
//                       //   context,
//                       //   RouteConstants.categoryProducts,
//                       //   arguments: category,
//                       // );
//                     },
//                   ),
//                 );
//               }).toList(),
//             ),
//           );
//         }

//         return const SizedBox();
//       },
//     );
//   }
// }