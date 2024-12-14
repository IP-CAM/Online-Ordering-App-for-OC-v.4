part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class FetchThemeEvent extends ThemeEvent {}

final class SaveThemeEvent extends ThemeEvent {
  final bool isDarkMode;

  SaveThemeEvent({required this.isDarkMode});
}
