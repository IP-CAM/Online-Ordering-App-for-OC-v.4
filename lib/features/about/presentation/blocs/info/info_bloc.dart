import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/about/domain/entities/info_entity.dart';
import 'package:ordering_app/features/about/domain/use_cases/fetch_info.dart';

part 'info_event.dart';
part 'info_state.dart';

class InfoBloc extends Bloc<InfoEvent, InfoState> {
  final FetchInfo _fetchInfo;
  InfoBloc({required FetchInfo fetchInfo})
      : _fetchInfo = fetchInfo,
        super(InfoInitial()) {
    on<InfoEvent>((event, emit) {
      emit(InfoLoading());
    });

    on<FetchInfoEvent>(_onFetchInfoEvent);
  }

  void _onFetchInfoEvent(FetchInfoEvent event, Emitter<InfoState> emit) async {
    final res = await _fetchInfo(NoParams());
    res.fold(
      (l) => emit(InfoFailure(error: l.message)),
      (r) => emit(InfoSuccess(info: r)),
    );
  }
}
