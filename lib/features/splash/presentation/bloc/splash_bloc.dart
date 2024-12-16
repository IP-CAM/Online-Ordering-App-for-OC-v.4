import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/splash/domain/use_cases/fetch_menu.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final FetchMenu _fetchMenu;

  SplashBloc({required FetchMenu fetchMenu})
      : _fetchMenu = fetchMenu,
        super(SplashInitial()) {
    on<SplashEvent>((event, emit) {
      emit(SplashLoading());
    });
    on<FetchMenuEvent>(_onFetchMenuEvent);
  }

  void _onFetchMenuEvent(
    FetchMenuEvent event,
    Emitter<SplashState> emit,
  ) async {
    final res = await _fetchMenu(NoParams());
    res.fold(
      (l) => emit(SplashFailure(l.message)),
      (r) => emit(SplashSuccess()),
    );
  }
}
