import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/use_case/use_case.dart';
import 'package:ordering_app/features/home/domain/entities/home_banner_entity.dart';
import 'package:ordering_app/features/home/domain/use_cases/fetch_home_banners.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final FetchHomeBanners _fetchHomeBanners;
  BannerBloc({required FetchHomeBanners fetchHomeBanners}) : _fetchHomeBanners = fetchHomeBanners, super(BannerInitial()) {
    on<BannerEvent>((event, emit) {
emit(BannerLoading());
    });
    on<FetchBannerEvent>(_onFetchBannerEvent);
  }

  void _onFetchBannerEvent(FetchBannerEvent event, Emitter<BannerState> emit,) async{
    final res = await _fetchHomeBanners(NoParams());
    res.fold((l) => emit(BannerFailure(l.message)), (r) => emit(BannerSuccess(r)),);
  }
}
