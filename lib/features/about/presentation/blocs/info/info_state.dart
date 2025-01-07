part of 'info_bloc.dart';

@immutable
sealed class InfoState {}

final class InfoInitial extends InfoState {}

final class InfoLoading extends InfoState {}

final class InfoSuccess extends InfoState {
  final InfoEntity info;

  InfoSuccess({required this.info});
}

final class InfoFailure extends InfoState {
  final String error;

  InfoFailure({required this.error});
}
