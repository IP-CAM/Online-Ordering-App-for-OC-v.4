import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/theme/domain/entities/theme_entity.dart';
import 'package:ordering_app/features/theme/domain/use_cases/fetch_theme.dart';
import 'package:ordering_app/features/theme/domain/use_cases/save_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final FetchTheme _fetchTheme;
  final SaveTheme _saveTheme;
  ThemeBloc({
    required FetchTheme fetchTheme,
    required SaveTheme saveTheme,
  })  : _saveTheme = saveTheme,
        _fetchTheme = fetchTheme,
        super(ThemeInitial()) {
    on<ThemeEvent>((event, emit) {
      emit(ThemeLoading());
    });

    on<FetchThemeEvent>(_onFetchThemeEvent);
    on<SaveThemeEvent>(_onSaveThemeEvent);
  }

  void _onFetchThemeEvent(
    FetchThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final result = await _fetchTheme(NoParams());
    result.fold(
      (l) => emit(ThemeFailure(error: l.message)),
      (r) => emit(ThemeSuccess(theme: r)),
    );
  }

  void _onSaveThemeEvent(
    SaveThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final result = await _saveTheme(SaveThemeParams(
      isDarkMode: event.isDarkMode,
    ));
    result.fold(
      (l) => emit(ThemeFailure(error: l.message)),
      (r) =>
          emit(ThemeSuccess(theme: ThemeEntity(isDarkMode: event.isDarkMode))),
    );
  }
}
