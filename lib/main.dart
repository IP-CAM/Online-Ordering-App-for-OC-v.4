import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/config/theme/custom_colors.dart';
import 'package:ordering_app/config/theme/theme.dart';
import 'package:ordering_app/core/dependencies/dependencies.dart';
import 'package:ordering_app/core/database/migrations.dart';
import 'package:ordering_app/features/home/presentation/pages/home_page.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injectDependencies();
  await initializeDatabase();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<ThemeBloc>()..add(FetchThemeEvent()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeMode _resolveThemeMode(ThemeState state) {
    if (state is ThemeSuccess) {
      return state.theme.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
    return ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final appTheme = AppTheme(colors: appColors);

        return MaterialApp(
          title: 'Ordering App',
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: _resolveThemeMode(state),
          home: const HomePage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
