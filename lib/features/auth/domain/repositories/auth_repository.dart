import 'package:fpdart/fpdart.dart';
import 'package:ordering_app/core/common/entities/login_info.dart';
import 'package:ordering_app/core/errors/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure,LoginInfoEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure,void>> logout();

  Future<Either<Failure,LoginInfoEntity>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String telephone,
    required String password,
    required String confirm,
    required bool agree,
    required bool newsletter,
  });
   Future<Either<Failure,LoginInfoEntity>> getLoginInfo();
}