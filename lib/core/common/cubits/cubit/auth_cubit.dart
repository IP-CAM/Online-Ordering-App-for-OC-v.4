import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ordering_app/core/common/entities/login_info_entity.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void authenticate({
    required LoginInfoEntity? loginInfoEntity,
  }) {
    if (loginInfoEntity == null) {
      emit(AuthInitial());
    } else {
      emit(AuthSuccess(loginInfoEntity));
    }
  }
}
