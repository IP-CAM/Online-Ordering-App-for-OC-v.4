import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/widgets/bottom_nav_bar.dart';
import 'package:ordering_app/features/home/presentation/blocs/banner/banner_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/featured_products/featured_products_bloc.dart';
import 'package:ordering_app/features/home/presentation/widgets/featured_products.dart';
import 'package:ordering_app/features/home/presentation/widgets/home_banner_slider.dart';
import 'package:ordering_app/features/home/presentation/widgets/manufacturers_slider.dart';
import 'package:ordering_app/features/theme/presentation/widgets/theme_mode_fab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerBloc>(context).add(FetchBannerEvent());
    BlocProvider.of<FeaturedProductsBloc>(context)
        .add(FetchFeaturedProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const ThemeModeFAB(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            BlocProvider.of<BannerBloc>(context).add(FetchBannerEvent());
            BlocProvider.of<FeaturedProductsBloc>(context)
                .add(FetchFeaturedProductsEvent());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeBannerSlider(),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Featured Products',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const FeaturedProducts(),
                  const SizedBox(height: 16),
                  const ManufacturersSlider(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
