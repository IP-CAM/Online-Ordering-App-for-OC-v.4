import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/home/presentation/widgets/home_banner_slider.dart';
import 'package:ordering_app/features/home/presentation/widgets/category_chips.dart';
import 'package:ordering_app/features/home/presentation/widgets/featured_products.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';
import 'package:ordering_app/core/utils/navigation_service.dart';
import 'package:ordering_app/core/utils/show_snackbar.dart';
import 'package:ordering_app/config/routes/route_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeModeFAB(),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar with search and cart
            SliverAppBar(
              floating: true,
              title: _buildSearchBar(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    NavigationService.push(context, RouteConstants.cart);
                  },
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthLogoutSuccess) {
                      showCustomSnackBar(
                        context: context,
                        message: "Logged out!",
                        type: SnackBarType.warning,
                      );
                      NavigationService.pushReplacement(
                        context,
                        RouteConstants.login,
                      );
                    }
                  },
                  child: IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ),
              ],
            ),
            
            // Category Chips
            const SliverPersistentHeader(
              pinned: true,
              delegate: SliverCategoryChipsDelegate(),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  // Banner Slider
                  HomeBannerSlider(),
                  
                  SizedBox(height: 16),
                  
                  // Featured Products
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Featured Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  FeaturedProducts(),
                  
                  SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        NavigationService.push(context, RouteConstants.search);
      },
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: const [
            Icon(Icons.search),
            SizedBox(width: 8),
            Text('Search products...'),
          ],
        ),
      ),
    );
  }
}