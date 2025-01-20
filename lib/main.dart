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
import 'package:ordering_app/features/checkout/presentation/blocs/cart/cart_bloc.dart';
import 'package:ordering_app/features/checkout/presentation/blocs/checkout/checkout_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/banner/banner_bloc.dart';
import 'package:ordering_app/features/home/presentation/blocs/featured_products/featured_products_bloc.dart';
import 'package:ordering_app/features/menu/presentation/blocs/menu/menu_bloc.dart';
import 'package:ordering_app/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ordering_app/core/constants/urls.dart';

// Connection State Management
enum ConnectionState {
  initial,
  checking,
  connected,
  error
}

// Connection Check Screen
class ConnectionCheckScreen extends StatefulWidget {
  final Widget child;
  const ConnectionCheckScreen({super.key, required this.child});

  @override
  State<ConnectionCheckScreen> createState() => _ConnectionCheckScreenState();
}

class _ConnectionCheckScreenState extends State<ConnectionCheckScreen> {
  ConnectionState connectionState = ConnectionState.initial;
  String? connectionError;
  Timer? _retryTimer;
  static const int _retryInterval = 5; // seconds

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  Future<void> checkConnection() async {
    if (mounted) {
      setState(() {
        connectionState = ConnectionState.checking;
        connectionError = null;
      });
    }

    try {
      final List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();
      
      if (connectivityResult.isEmpty || 
          connectivityResult.every((result) => result == ConnectivityResult.none)) {
        if (mounted) {
          setState(() {
            connectionError = 'No internet connection';
            connectionState = ConnectionState.error;
          });
        }
        _scheduleRetry();
        return;
      }

      final response = await http.get(Uri.parse('${Urls.baseUrl}${Urls.connectionTest}'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode != 200) {
        if (mounted) {
          setState(() {
            connectionError = 'Server error: ${response.statusCode}';
            connectionState = ConnectionState.error;
          });
        }
        _scheduleRetry();
        return;
      }

      if (mounted) {
        setState(() {
          connectionState = ConnectionState.connected;
        });
      }
      
    } on SocketException {
      if (mounted) {
        setState(() {
          connectionError = 'Cannot reach server';
          connectionState = ConnectionState.error;
        });
      }
      _scheduleRetry();
    } on TimeoutException {
      if (mounted) {
        setState(() {
          connectionError = 'Connection timeout';
          connectionState = ConnectionState.error;
        });
      }
      _scheduleRetry();
    } catch (e) {
      if (mounted) {
        setState(() {
          connectionError = 'Connection error: $e';
          connectionState = ConnectionState.error;
        });
      }
      _scheduleRetry();
    }
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: _retryInterval), () {
      if (connectionState == ConnectionState.error) {
        checkConnection();
      }
    });
  }

  Widget _buildLoadingScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: appColors.primary,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),
                SpinKitFadingCube(
                  color: appColors.surfaceLight,
                  size: 50.0,
                ),
                const SizedBox(height: 20),
                Text(
                  'Checking connection...',
                  style: TextStyle(
                    color: appColors.surfaceLight,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: appColors.primary,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 300,
                  height: 300,
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.error_outline,
                  size: 50,
                  color: appColors.surfaceLight,
                ),
                const SizedBox(height: 20),
                Text(
                  connectionError ?? 'Connection Error',
                  style: TextStyle(
                    color: appColors.surfaceLight,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Retrying in $_retryInterval seconds...',
                  style: TextStyle(
                    color: appColors.surfaceLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: checkConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.surfaceLight,
                    foregroundColor: appColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Retry Now',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (connectionState) {
      case ConnectionState.checking:
        return _buildLoadingScreen();
      case ConnectionState.error:
        return _buildErrorScreen();
      case ConnectionState.connected:
      case ConnectionState.initial:
        return widget.child;
    }
  }
}

// App Root
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
        BlocProvider(
          create: (_) => serviceLocator<CheckoutBloc>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

// MyApp
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

// Main Function
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

  runApp(const ConnectionCheckScreen(child: AppRoot()));
}