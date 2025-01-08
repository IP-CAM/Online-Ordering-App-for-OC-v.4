import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/routes/router_config.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import 'package:ordering_app/config/theme/app_theme.dart';
import 'package:ordering_app/core/common/cubits/cubit/auth_cubit.dart';
import 'package:ordering_app/core/dependencies/dependencies.dart';
import 'package:ordering_app/core/database/migrations.dart';
import 'package:ordering_app/features/about/presentation/blocs/info/info_bloc.dart';
import 'package:ordering_app/features/address_book/presentation/blocs/address_book/address_book_bloc.dart';
import 'package:ordering_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ordering_app/features/cart/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/banner/banner_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/featured_products/featured_products_bloc.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies and database
  await injectDependencies();
  await initializeDatabase();

  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<ThemeBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<SplashBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<BannerBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<FeaturedProductsBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AddressBookBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<InfoBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<MenuBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<CartBloc>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _resolveThemeMode(ThemeState state) {
    if (state is ThemeSuccess) {
      return state.theme.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
    return ThemeMode.system;
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ThemeBloc>(context).add(FetchThemeEvent());
    BlocProvider.of<AuthBloc>(context).add(FetchLoginInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final appTheme = AppTheme(colors: appColors);
        return MaterialApp.router(
          title: 'Ordering App',
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: _resolveThemeMode(state),
          routerConfig: AppRouter.instance.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
