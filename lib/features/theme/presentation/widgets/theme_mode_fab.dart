import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/features/theme/presentation/bloc/theme_bloc.dart';

class ThemeModeFAB extends StatelessWidget {
  const ThemeModeFAB({super.key});

  void _onThemeToggle(BuildContext context, ThemeState currentState) {
    if (currentState is ThemeSuccess) {
      // Toggle between light and dark, defaulting to light if in system mode
      final newIsDarkMode = currentState.theme.isDarkMode ? false : true;

      context.read<ThemeBloc>().add(
            SaveThemeEvent(isDarkMode: newIsDarkMode),
          );
    } else if (currentState is ThemeFailure) {
      // On failure, use the system's current brightness
      final isDarkMode =
          MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      context.read<ThemeBloc>().add(
            SaveThemeEvent(isDarkMode: isDarkMode),
          );
    }
  }

  Widget _buildFAB(BuildContext context, ThemeState state) {
    if (state is ThemeLoading) {
      return FloatingActionButton(
        onPressed: null,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    if (state is ThemeSuccess) {
      return FloatingActionButton(
        onPressed: () => _onThemeToggle(context, state),
        tooltip: 'Toggle Theme Mode',
        child: _getThemeModeIcon(state.theme.isDarkMode),
      );
    }

    if (state is ThemeFailure) {
      final isDarkMode =
          MediaQuery.platformBrightnessOf(context) == Brightness.dark;
      return FloatingActionButton(
        onPressed: () => _onThemeToggle(context, state),
        tooltip: 'Toggle Theme Mode',
        child: _getThemeModeIcon(isDarkMode),
      );
    }

    // Fallback for any unexpected state
    return FloatingActionButton(
      onPressed: null,
      child:
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
    );
  }

  Widget _getThemeModeIcon(bool isDarkMode) {
    return Icon(
      isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return _buildFAB(context, state);
      },
    );
  }
}
