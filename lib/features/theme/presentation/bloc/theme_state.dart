part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}
final class ThemeLoading extends ThemeState {}
final class ThemeSuccess extends ThemeState {
  final ThemeEntity theme;

  ThemeSuccess({required this.theme});
}
final class ThemeFailure extends ThemeState {
  final String error;

  ThemeFailure({required this.error});
}


