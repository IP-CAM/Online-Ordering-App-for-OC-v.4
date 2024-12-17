part of 'banner_bloc.dart';

@immutable
sealed class BannerState {}

final class BannerInitial extends BannerState {}
final class BannerLoading extends BannerState {}
final class BannerSuccess extends BannerState {
  final List<HomeBannerEntity> banners;

  BannerSuccess(this.banners);
}
final class BannerFailure extends BannerState {
  final String error;

  BannerFailure(this.error);
}
