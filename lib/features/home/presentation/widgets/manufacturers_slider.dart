import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/banner/banner_bloc.dart';

class ManufacturersSlider extends StatelessWidget {
  const ManufacturersSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is BannerSuccess && state.banners.isNotEmpty) {
          final slides = state.banners
              .where((banner) => banner.name == 'Homepage Manufacturers')
              .expand((banner) => banner.slides)
              .toList();

          if (slides.isEmpty) return const SizedBox();

          return Stack(
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                  height: 100,
                  viewportFraction: .5,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
                itemCount: slides.length,
                itemBuilder: (context, index, realIndex) {
                  return Container(
                    margin: const EdgeInsets.symmetric( vertical: 16,horizontal: 10,),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            slides[index].image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (slides[index].link.isNotEmpty) {
                                  // Implement banner click action
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}