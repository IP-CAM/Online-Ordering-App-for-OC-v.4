import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/entities/category_entity.dart';
import 'package:ordering_app/core/utils/loader.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/menu/presentation/widgets/category_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<CategoryEntity> _categories = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MenuBloc>(context).add(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocConsumer<MenuBloc, MenuState>(
          listener: (context, state) {
            if (state is MenuFailure) {
              showCustomSnackBar(
                context: context,
                message: state.error,
                type: SnackBarType.error,
              );
            }
            if (state is MenuLoading) {
              Loader.show(context);
            } else {
              Loader.hide();
            }

            if (state is CategorySuccess) {
              setState(() {
                _categories = state.categories;
              });
            }
          },
          builder: (context, state) {
            return LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the optimal number of columns based on screen width
                 const double itemWidth = 180; // Desired card width
                final int crossAxisCount = 
                    (constraints.maxWidth / itemWidth).floor();
                
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount.clamp(2, 4), // Min 2, Max 4 columns
                    childAspectRatio: 0.8, // Adjust based on your card design
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) => 
                    CategoryCard(category: _categories[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}